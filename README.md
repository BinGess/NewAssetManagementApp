# New Asset Management App

家庭资产管理 Flutter 客户端。

## 服务端调试

默认 API 地址是 `http://127.0.0.1:3000/api/v1`。如果服务端不是这个地址，可以在启动 App 时覆盖：

```bash
flutter run \
  --dart-define=ASSET_API_BASE_URL=http://127.0.0.1:3000/api/v1
```

iOS 模拟器和 macOS 本机调试通常可以使用 `127.0.0.1`。Android 模拟器访问宿主机服务端通常要使用 `10.0.2.2`：

```bash
flutter run \
  --dart-define=ASSET_API_BASE_URL=http://10.0.2.2:3000/api/v1
```

如果是真机调试，需要换成电脑在局域网内的 IP 地址，例如：

```bash
flutter run \
  --dart-define=ASSET_API_BASE_URL=http://192.168.1.10:3000/api/v1
```

正式部署到 Sealos 后建议使用 HTTPS 域名作为 `ASSET_API_BASE_URL`。
