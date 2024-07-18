# Case reproduction

**Issue description:**

Exporting a YOLO model fails when the current directory filesystem (where pnnx is downloaded) is different to the filesystem where `/usr/local/lib/` is located (where pnnx is moved to).


## Setup Environment


**Build docker image:**

```bash
docker build . \
    -f Dockerfile \
    -t some_image_name
```

**Versions:**

```
ultralytics==8.2.59
torch==2.3.1
```

See all versions in [versions.txt](./versions.txt).

## Issue Reproduction

**Run YOLO export inside created container:**

```bash
docker run --rm -v $(pwd):/workdir -w /workdir some_image_name bash -c "/usr/local/bin/python -c 'from ultralytics import YOLO; YOLO(\"yolov8n-pose.pt\", task=\"pose\").export(format=\"ncnn\", imgsz=640, half=False, batch=1)'"
```

**Result:**

```console
$ docker run --rm -v $(pwd):/workdir -w /workdir some_image_name /usr/local/bin/python -c 'from ultralytics import YOLO;
YOLO("yolov8n-pose.pt", task="pose").export(
    format="ncnn",
    imgsz=640,
    half=False,
    batch=1
)'

Downloading https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n-pose.pt to 'yolov8n-pose.pt'...
100%|██████████| 6.52M/6.52M [00:00<00:00, 15.9MB/s]
Ultralytics YOLOv8.2.59 🚀 Python-3.9.19 torch-2.3.1+cu121 CPU (Intel Core(TM) i7-8550U 1.80GHz)
YOLOv8n-pose summary (fused): 187 layers, 3,289,964 parameters, 0 gradients, 9.2 GFLOPs

PyTorch: starting from 'yolov8n-pose.pt' with input shape (1, 3, 640, 640) BCHW and output shape(s) (1, 56, 8400) (6.5 MB)

TorchScript: starting export with torch 2.3.1+cu121...
TorchScript: export success ✅ 4.4s, saved as 'yolov8n-pose.torchscript' (13.0 MB)
requirements: Ultralytics requirement ['ncnn'] not found, attempting AutoUpdate...
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager, possibly rendering your system unusable.It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv. Use the --root-user-action option if you know what you are doing and want to suppress this warning.
Collecting ncnn
  Downloading ncnn-1.0.20240410-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (26 kB)
Requirement already satisfied: numpy in /usr/local/lib/python3.9/site-packages (from ncnn) (1.26.4)
Requirement already satisfied: tqdm in /usr/local/lib/python3.9/site-packages (from ncnn) (4.66.4)
Requirement already satisfied: requests in /usr/local/lib/python3.9/site-packages (from ncnn) (2.32.3)
Collecting portalocker (from ncnn)
  Downloading portalocker-2.10.1-py3-none-any.whl.metadata (8.5 kB)
Requirement already satisfied: opencv-python in /usr/local/lib/python3.9/site-packages (from ncnn) (4.10.0.84)
Requirement already satisfied: charset-normalizer<4,>=2 in /usr/local/lib/python3.9/site-packages (from requests->ncnn) (3.3.2)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.9/site-packages (from requests->ncnn) (3.7)
Requirement already satisfied: urllib3<3,>=1.21.1 in /usr/local/lib/python3.9/site-packages (from requests->ncnn) (2.2.2)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.9/site-packages (from requests->ncnn) (2024.7.4)
Downloading ncnn-1.0.20240410-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (5.1 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 5.1/5.1 MB 2.8 MB/s eta 0:00:00
Downloading portalocker-2.10.1-py3-none-any.whl (18 kB)
Installing collected packages: portalocker, ncnn
Successfully installed ncnn-1.0.20240410 portalocker-2.10.1

requirements: AutoUpdate success ✅ 5.8s, installed 1 package: ['ncnn']
requirements: ⚠️ Restart runtime or rerun command for updates to take effect


NCNN: starting export with NCNN 1.0.20240410...
NCNN: WARNING ⚠️ PNNX not found. Attempting to download binary file from https://github.com/pnnx/pnnx/.
Note PNNX Binary file must be placed in current working directory or in /usr/local/lib/python3.9/site-packages/ultralytics. See PNNX repo for full installation instructions.
NCNN: successfully found latest PNNX asset file pnnx-20240715-linux.zip
Downloading https://github.com/pnnx/pnnx/releases/download/20240715/pnnx-20240715-linux.zip to 'pnnx-20240715-linux.zip'...
100%|██████████| 20.8M/20.8M [00:01<00:00, 13.1MB/s]
Unzipping pnnx-20240715-linux.zip to /workdir/pnnx-20240715-linux...: 100%|██████████| 3/3 [00:00<00:00,  4.97file/s]
Traceback (most recent call last):
  File "<string>", line 2, in <module>
NCNN: export failure ❌ 10.3s: [Errno 18] Invalid cross-device link: '/workdir/pnnx-20240715-linux/pnnx' -> '/usr/local/lib/python3.9/site-packages/ultralytics/pnnx'
  File "/usr/local/lib/python3.9/site-packages/ultralytics/engine/model.py", line 593, in export
    return Exporter(overrides=args, _callbacks=self.callbacks)(model=self.model)
  File "/usr/local/lib/python3.9/site-packages/torch/utils/_contextlib.py", line 115, in decorate_context
    return func(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/ultralytics/engine/exporter.py", line 325, in __call__
    f[11], _ = self.export_ncnn()
  File "/usr/local/lib/python3.9/site-packages/ultralytics/engine/exporter.py", line 142, in outer_func
    raise e
  File "/usr/local/lib/python3.9/site-packages/ultralytics/engine/exporter.py", line 137, in outer_func
    f, model = inner_func(*args, **kwargs)
  File "/usr/local/lib/python3.9/site-packages/ultralytics/engine/exporter.py", line 566, in export_ncnn
    (unzip_dir / name).rename(pnnx)  # move binary to ROOT
  File "/usr/local/lib/python3.9/pathlib.py", line 1382, in rename
    self._accessor.rename(self, target)
OSError: [Errno 18] Invalid cross-device link: '/workdir/pnnx-20240715-linux/pnnx' -> '/usr/local/lib/python3.9/site-packages/ultralytics/pnnx'
```

## Proposed fix

Replace `Path.rename()` with `shutil.move()` to move Pnxx's binary.

**Diff:**

```console
$ cat exporter.patch
commit bbaebed8a9f45fa9af12d72858f82c08779ecc31
Author: akukulanski <akukulanski@gmail.com>
Date:   Thu Jul 18 11:01:06 2024 -0300

    Fix exporter to support working in a different filesystem than the one of /usr

diff --git a/ultralytics/engine/exporter.py b/ultralytics/engine/exporter.py
index 47466e3..59eb1ae 100644
--- a/ultralytics/engine/exporter.py
+++ b/ultralytics/engine/exporter.py
@@ -563,7 +563,7 @@ class Exporter:
                 LOGGER.warning(f"{prefix} WARNING ⚠️ PNNX GitHub assets not found: {e}, using default {asset}")
             unzip_dir = safe_download(f"https://github.com/pnnx/pnnx/releases/download/{release}/{asset}", delete=True)
             if check_is_path_safe(Path.cwd(), unzip_dir):  # avoid path traversal security vulnerability
-                (unzip_dir / name).rename(pnnx)  # move binary to ROOT
+                shutil.move(src=unzip_dir / name, dst=pnnx)  # move binary to ROOT
                 pnnx.chmod(0o777)  # set read, write, and execute permissions for everyone
                 shutil.rmtree(unzip_dir)  # delete unzip dir
```

**Test:**

```bash
docker run --rm -v $(pwd):/workdir -w /workdir some_image_name bash -c "patch -b /usr/local/lib/python3.9/site-packages/ultralytics/engine/exporter.py exporter.patch; /usr/local/bin/python -c 'from ultralytics import YOLO; YOLO(\"yolov8n-pose.pt\", task=\"pose\").export(format=\"ncnn\", imgsz=640, half=False, batch=1)'"
```

**Result:**

```console
$ docker run --rm -v $(pwd):/workdir -w /workdir some_image_name bash -c "patch -b /usr/local/lib/python3.9/site-packages/ultralytics/engine/exporter.py exporter.patch; /usr/local/bin/python -c 'from ultralytics import YOLO; YOLO(\"yolov8n-pose.pt\", task=\"pose\").export(format=\"ncnn\", imgsz=640, half=False, batch=1)'"
patching file /usr/local/lib/python3.9/site-packages/ultralytics/engine/exporter.py
Downloading https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n-pose.pt to 'yolov8n-pose.pt'...
100%|██████████| 6.52M/6.52M [00:00<00:00, 16.1MB/s]
Ultralytics YOLOv8.2.59 🚀 Python-3.9.19 torch-2.3.1+cu121 CPU (Intel Core(TM) i7-8550U 1.80GHz)
YOLOv8n-pose summary (fused): 187 layers, 3,289,964 parameters, 0 gradients, 9.2 GFLOPs

PyTorch: starting from 'yolov8n-pose.pt' with input shape (1, 3, 640, 640) BCHW and output shape(s) (1, 56, 8400) (6.5 MB)

TorchScript: starting export with torch 2.3.1+cu121...
TorchScript: export success ✅ 2.7s, saved as 'yolov8n-pose.torchscript' (13.0 MB)
requirements: Ultralytics requirement ['ncnn'] not found, attempting AutoUpdate...
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager, possibly rendering your system unusable.It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv. Use the --root-user-action option if you know what you are doing and want to suppress this warning.
Collecting ncnn
  Downloading ncnn-1.0.20240410-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (26 kB)
Requirement already satisfied: numpy in /usr/local/lib/python3.9/site-packages (from ncnn) (1.26.4)
Requirement already satisfied: tqdm in /usr/local/lib/python3.9/site-packages (from ncnn) (4.66.4)
Requirement already satisfied: requests in /usr/local/lib/python3.9/site-packages (from ncnn) (2.32.3)
Collecting portalocker (from ncnn)
  Downloading portalocker-2.10.1-py3-none-any.whl.metadata (8.5 kB)
Requirement already satisfied: opencv-python in /usr/local/lib/python3.9/site-packages (from ncnn) (4.10.0.84)
Requirement already satisfied: charset-normalizer<4,>=2 in /usr/local/lib/python3.9/site-packages (from requests->ncnn) (3.3.2)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.9/site-packages (from requests->ncnn) (3.7)
Requirement already satisfied: urllib3<3,>=1.21.1 in /usr/local/lib/python3.9/site-packages (from requests->ncnn) (2.2.2)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.9/site-packages (from requests->ncnn) (2024.7.4)
Downloading ncnn-1.0.20240410-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (5.1 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 5.1/5.1 MB 2.0 MB/s eta 0:00:00
Downloading portalocker-2.10.1-py3-none-any.whl (18 kB)
Installing collected packages: portalocker, ncnn
Successfully installed ncnn-1.0.20240410 portalocker-2.10.1

requirements: AutoUpdate success ✅ 6.0s, installed 1 package: ['ncnn']
requirements: ⚠️ Restart runtime or rerun command for updates to take effect


NCNN: starting export with NCNN 1.0.20240410...
NCNN: WARNING ⚠️ PNNX not found. Attempting to download binary file from https://github.com/pnnx/pnnx/.
Note PNNX Binary file must be placed in current working directory or in /usr/local/lib/python3.9/site-packages/ultralytics. See PNNX repo for full installation instructions.
NCNN: successfully found latest PNNX asset file pnnx-20240715-linux.zip
Downloading https://github.com/pnnx/pnnx/releases/download/20240715/pnnx-20240715-linux.zip to 'pnnx-20240715-linux.zip'...
100%|██████████| 20.8M/20.8M [00:01<00:00, 17.8MB/s]
Unzipping pnnx-20240715-linux.zip to /workdir/pnnx-20240715-linux...: 100%|██████████| 3/3 [00:00<00:00,  6.18file/s]
NCNN: running '/usr/local/lib/python3.9/site-packages/ultralytics/pnnx yolov8n-pose.torchscript ncnnparam=yolov8n-pose_ncnn_model/model.ncnn.param ncnnbin=yolov8n-pose_ncnn_model/model.ncnn.bin ncnnpy=yolov8n-pose_ncnn_model/model_ncnn.py pnnxparam=yolov8n-pose_ncnn_model/model.pnnx.param pnnxbin=yolov8n-pose_ncnn_model/model.pnnx.bin pnnxpy=yolov8n-pose_ncnn_model/model_pnnx.py pnnxonnx=yolov8n-pose_ncnn_model/model.pnnx.onnx fp16=0 device=cpu inputshape="[1, 3, 640, 640]"'
pnnxparam = yolov8n-pose_ncnn_model/model.pnnx.param
pnnxbin = yolov8n-pose_ncnn_model/model.pnnx.bin
pnnxpy = yolov8n-pose_ncnn_model/model_pnnx.py
pnnxonnx = yolov8n-pose_ncnn_model/model.pnnx.onnx
ncnnparam = yolov8n-pose_ncnn_model/model.ncnn.param
ncnnbin = yolov8n-pose_ncnn_model/model.ncnn.bin
ncnnpy = yolov8n-pose_ncnn_model/model_ncnn.py
fp16 = 0
optlevel = 2
device = cpu
inputshape = [1,3,640,640]f32
inputshape2 =
customop =
moduleop =
############# pass_level0
inline module = ultralytics.nn.modules.block.Bottleneck
inline module = ultralytics.nn.modules.block.C2f
inline module = ultralytics.nn.modules.block.DFL
inline module = ultralytics.nn.modules.block.SPPF
inline module = ultralytics.nn.modules.conv.Concat
inline module = ultralytics.nn.modules.conv.Conv
inline module = ultralytics.nn.modules.head.Pose
inline module = ultralytics.nn.modules.block.Bottleneck
inline module = ultralytics.nn.modules.block.C2f
inline module = ultralytics.nn.modules.block.DFL
inline module = ultralytics.nn.modules.block.SPPF
inline module = ultralytics.nn.modules.conv.Concat
inline module = ultralytics.nn.modules.conv.Conv
inline module = ultralytics.nn.modules.head.Pose

----------------

############# pass_level1
############# pass_level2
############# pass_level3
############# pass_level4
############# pass_level5
############# pass_ncnn
NCNN: export success ✅ 11.8s, saved as 'yolov8n-pose_ncnn_model' (12.8 MB)

Export complete (16.7s)
Results saved to /workdir
Predict:         yolo predict task=pose model=yolov8n-pose_ncnn_model imgsz=640
Validate:        yolo val task=pose model=yolov8n-pose_ncnn_model imgsz=640 data=/usr/src/app/ultralytics/datasets/coco-pose.yaml
Visualize:       https://netron.app
```
