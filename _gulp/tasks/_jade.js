var gulp = require('gulp'),
    jade = require('gulp-jade');

// Compile jade files to root
gulp.task('jade', function() {
    gulp.src('src/jade/index.jade')
    .pipe(jade())
    .pipe(gulp.dest('www/'));
    return gulp.src(['src/jade/*.jade', '!src/jade/index.jade'])
        .pipe(jade())
        .pipe(gulp.dest('www/html'));
});

