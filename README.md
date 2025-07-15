# vitrivr-VR for visionOS

An immersive multimedia retrieval interface built from the ground up for the Apple Vision Pro.

## Requirements

Relies on access to a running instance of [FERElight](https://github.com/FEREorg/ferelight).

## Configuration

The following options are configured in the settings app after installation:
- **Media Host:** URL to the host of media files.
- **FERElight Host:** URL to the host of the FERElight backend.
- **DRES Host:** URL to the host of the DRES server (only needed for evaluation campaigns).
- **DRES Username:** Username to connect to the DRES server.
- **DRES Password:** Password to connect to the DRES server.

The following is an example of resource path configurations for two databases (V3C and ImageNet):
```json
{
  "collections": {
    "v3c": {
      "name": "V3C",
      "thumbnailPattern": "thumbnails/:oid/:id.jpg",
      "mediaPattern": "video-480p/:oid.mp4"
    },
    "imagenet": {
      "name": "ImageNet",
      "thumbnailPattern": "val/:oid.JPEG",
      "mediaPattern": "val/:oid.JPEG"
    }
  }
}
```
