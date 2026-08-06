python -c "
import sys

print('='*60)
print('PYTHON')
print('='*60)
print('Version          :', sys.version)
print('Executable       :', sys.executable)

modules = [
    ('torch', '__version__'),
    ('torchvision', '__version__'),
    ('pytorch_lightning', '__version__'),
    ('torchmetrics', '__version__'),
    ('detectron2', '__version__'),
    ('cv2', '__version__'),
    ('numpy', '__version__'),
    ('flask', '__version__'),
    ('yaml', '__version__'),
]

print('\n' + '='*60)
print('PACKAGES')
print('='*60)

for mod, attr in modules:
    try:
        m = __import__(mod)
        print(f'{mod:<20}: {getattr(m, attr, \"N/A\")}')
    except Exception as e:
        print(f'{mod:<20}: NOT INSTALLED ({e})')

print('\n' + '='*60)
print('CUDA')
print('='*60)

try:
    import torch
    print('CUDA Available   :', torch.cuda.is_available())
    print('CUDA Version     :', torch.version.cuda)
    print('GPU Count        :', torch.cuda.device_count())
    if torch.cuda.is_available():
        for i in range(torch.cuda.device_count()):
            print(f'GPU {i} Name      :', torch.cuda.get_device_name(i))
except Exception as e:
    print('Torch Error      :', e)

print('\n' + '='*60)
print('PROJECT IMPORTS')
print('='*60)

try:
    from src.lstm import ActionClassificationLSTM
    print('src.lstm         : OK')
except Exception as e:
    print('src.lstm         :', e)

try:
    from src.video_analyzer import *
    print('src.video_analyzer: OK')
except Exception as e:
    print('src.video_analyzer:', e)

try:
    from detectron2.engine import DefaultPredictor
    print('Detectron2       : OK')
except Exception as e:
    print('Detectron2       :', e)

print('\nEnvironment check completed.')
"
