"""
ClangBenchmark Leaderboard API Server
Run: python3 server.py
Deploy anywhere (render.com, fly.io, railway, etc.)
"""
import json, os, time
from http.server import HTTPServer, BaseHTTPRequestHandler

DATA_FILE = "leaderboard_data.json"
MAX_ENTRIES = 100

def load_data():
    try:
        with open(DATA_FILE) as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return []

def save_data(data):
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=2)

class Handler(BaseHTTPRequestHandler):
    def _cors(self, status=200):
        self.send_response(status)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.send_header("Content-Type", "application/json")
        self.end_headers()

    def do_OPTIONS(self):
        self._cors()

    def do_GET(self):
        if self.path == "/api/leaderboard":
            data = load_data()
            # Sort by score descending
            data.sort(key=lambda x: x.get("score", 0), reverse=True)
            self._cors()
            self.wfile.write(json.dumps(data[:MAX_ENTRIES]).encode())
        else:
            self._cors(404)
            self.wfile.write(b'{"error":"not found"}')

    def do_POST(self):
        if self.path == "/api/results":
            content_len = int(self.headers.get("Content-Length", 0))
            body = json.loads(self.rfile.read(content_len))
            
            entry = {
                "name": body.get("name", "Unknown"),
                "cpu": body.get("cpu", "Unknown"),
                "cpuCores": body.get("cpuCores", 0),
                "gpuCores": body.get("gpuCores", 0),
                "score": body.get("score", 0),
                "klinesPerSec": body.get("klinesPerSec", 0),
                "osVersion": body.get("osVersion", ""),
                "clangVersion": body.get("clangVersion", ""),
                "timestamp": time.strftime("%Y-%m-%d %H:%M:%S UTC", time.gmtime())
            }
            
            data = load_data()
            data.append(entry)
            data.sort(key=lambda x: x.get("score", 0), reverse=True)
            data = data[:MAX_ENTRIES]
            save_data(data)
            
            self._cors(201)
            self.wfile.write(json.dumps({"ok": True, "rank": len(data)}).encode())
        else:
            self._cors(404)
            self.wfile.write(b'{"error":"not found"}')

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    print(f"🚀 ClangBenchmark API on :{port}")
    HTTPServer(("0.0.0.0", port), Handler).serve_forever()
