let path = require('path');
let vfs = require('vinyl-fs');
let through = require('through2');
let sassdoc = require('../src/sassdoc');

function inspect() {
  let count = 0;

  return through.obj((chunk, enc, cb) => {
    count++;
    cb(null, chunk);
  }, (cb) => {
    console.log(count);
    cb();
  });
}

function documentize() {
  return sassdoc('./test/data', { verbose: true })
    .then(() => {
      console.log('yeah!');
    });
}

function stream() {
  return vfs.src('./test/data/**/*.scss')
    .pipe(sassdoc({ verbose: true }))
    .pipe(inspect())
    .on('data', () => {});
}

(async function () {
  try {
    await documentize();
    stream();
  }
  catch (err) {
    console.error(err);
  }
}());