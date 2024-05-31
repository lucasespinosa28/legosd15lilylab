# legolilypadsd15
To create your lilypad workflow use the command above
creatad using [createlilypadconfyui](https://github.com/lucasespinosa28/createlilypadconfyui).
## To build
```bash
docker build . -f Dockerfile -t espinosa1991/legolilypadsd15:0.1 --target runner
```
## To run
```bash
docker run -it --gpus all -v $PWD/outputs:/outputs -e PROMPT="RAW photo, <lora:lego_v2.0.768-000035:0.8> LEGO BrickHeadz, a dragon in a cave, (high detailed skin:1.2), 8k uhd, dslr, soft lighting, high quality, film grain, Fujifilm XT3"
```
## To publish
```bash
docker push espinosa1991/legolilypadsd15:0.1
```
## To run your worklow at lilypad
```bash
export WEB3_PRIVATE_KEY=<walletprivatekey>
lilypad run github.com/lucasespinosa28/legosd15lilylab:v1.0 -i Prompt="RAW photo, <lora:lego_v2.0.768-000035:0.8> LEGO BrickHeadz, a dragon in a cave, (high detailed skin:1.2), 8k uhd, dslr, soft lighting, high quality, film grain, Fujifilm XT3"
```
