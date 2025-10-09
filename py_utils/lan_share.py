"""Simple HTTP server to share a file over LAN."""

import argparse
import http.server
import signal
import socket
import socketserver
import sys
import threading
from contextlib import closing, contextmanager
from pathlib import Path
from textwrap import dedent


class FileRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Handler that serves a single file regardless of the request path."""

    def __init__(self, *args, file_path: Path, **kwargs):
        self.file_to_serve = file_path
        super().__init__(*args, **kwargs)

    def translate_path(self, path):
        """Always return the absolute path of the file to serve."""
        return str(self.file_to_serve.resolve().absolute())

    def log_message(self, format, *args):
        """Override to provide cleaner logging."""
        print(f"{self.address_string()} - {format % args}")


class ReuseAddrTCPServer(socketserver.TCPServer):
    """TCP server with SO_REUSEADDR enabled for immediate port reuse."""

    allow_reuse_address = True
    daemon_threads = True


def get_local_ip() -> str:
    """Get the local IP address of the machine."""
    with closing(socket.socket(socket.AF_INET, socket.SOCK_DGRAM)) as s:
        try:
            s.connect(("10.255.255.255", 1))
            return s.getsockname()[0]
        except Exception:
            return "127.0.0.1"


@contextmanager
def file_server(file_path: Path, port: int = 8080):
    """Context manager for running the file server with proper cleanup."""
    handler = lambda *args, **kwargs: FileRequestHandler(
        *args, file_path=file_path, **kwargs
    )

    server = ReuseAddrTCPServer(("", port), handler)

    def shutdown_handler(signum, frame):
        print("\n🛑 Shutting down server...")
        threading.Thread(target=server.shutdown).start()

    signal.signal(signal.SIGINT, shutdown_handler)
    signal.signal(signal.SIGTERM, shutdown_handler)

    try:
        yield server
    finally:
        server.shutdown()
        server.server_close()


def serve_file(file_path: Path, port: int = 8080) -> None:
    """Serve a single file over HTTP."""
    if not file_path.exists():
        print(f"❌ Error: File '{file_path}' does not exist")
        sys.exit(1)

    print(f"📁 Serving: {file_path.name}")
    print(f"📍 Local URL: http://{get_local_ip()}:{port}")
    print(f"📍 Localhost: http://127.0.0.1:{port}")
    print(f"📦 Size: {file_path.stat().st_size:,} bytes")

    with file_server(file_path, port) as server:
        server.serve_forever()


def main() -> None:
    """Main entry point with argument parsing."""
    parser = argparse.ArgumentParser(
        description="Share a file over your local network",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=dedent(
            """
            Examples:
              %(prog)s document.pdf
              %(prog)s -p 9000 movie.mp4
              %(prog)s ~/Downloads/archive.zip
            """
        ),
    )

    parser.add_argument("file", type=Path, help="Path to the file to serve")

    parser.add_argument(
        "-p", "--port", type=int, default=8080, help="Port to serve on (default: 8080)"
    )

    args = parser.parse_args()
    serve_file(args.file.expanduser().resolve(), args.port)


if __name__ == "__main__":
    main()
