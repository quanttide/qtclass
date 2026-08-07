#!/usr/bin/env python3
"""本地预览 Flutter Web 产物（build/web）的静态文件服务器。

支持 Range 请求（206 响应）——Flutter Web 播放视频依赖浏览器分片加载，
python 自带的 http.server 不支持 Range 会导致视频无法加载。

用法:
    python3 scripts/serve-web.py [PORT] [DIR]
    # 默认端口 8080，目录 build/web；需先 flutter build web --release
"""
import http.server
import os
import re
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
DIR = sys.argv[2] if len(sys.argv) > 2 else "build/web"


class RangeHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIR, **kwargs)

    def send_head(self):
        path = self.translate_path(self.path)
        if not os.path.isfile(path):
            return super().send_head()

        size = os.path.getsize(path)
        range_header = self.headers.get("Range")
        if range_header:
            m = re.match(r"bytes=(\d*)-(\d*)", range_header)
            if m:
                start = int(m.group(1) or 0)
                end = int(m.group(2) or size - 1)
                end = min(end, size - 1)
                if start > end or start >= size:
                    self.send_response(416)
                    self.send_header("Content-Range", f"bytes */{size}")
                    self.end_headers()
                    return None
                length = end - start + 1
                self.send_response(206)
                self.send_header("Content-Type", self.guess_type(path))
                self.send_header("Content-Range", f"bytes {start}-{end}/{size}")
                self.send_header("Accept-Ranges", "bytes")
                self.send_header("Content-Length", str(length))
                self.end_headers()
                f = open(path, "rb")
                f.seek(start)
                return f

        return super().send_head()


if __name__ == "__main__":
    http.server.ThreadingHTTPServer(
        ("0.0.0.0", PORT), RangeHandler
    ).serve_forever()
