var gulp    = require('gulp'),
    changed = require('gulp-changed');

var DEST = 'www/vendor';

gulp.task('copy-dep', function () {
  return gulp.src('src/vendor/**')
      .pipe(changed(DEST))
      .pipe(gulp.dest(DEST));
});
