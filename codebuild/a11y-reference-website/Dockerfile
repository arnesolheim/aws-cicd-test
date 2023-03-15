FROM public.ecr.aws/docker/library/node:16-bullseye
WORKDIR a11y-reference-website
COPY a11y-reference-website .
RUN npm install -g node-gyp
RUN npm install
EXPOSE 8000
CMD npm start
