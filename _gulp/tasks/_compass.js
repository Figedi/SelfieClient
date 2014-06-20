var gulp    = require('gulp'),
    compass = require('gulp-compass'),
    csso    = require('gulp-csso'),
    gutil   = require('gulp-util');
//compass (scss)
gulp.task('compass', function() {
    return gulp.src(['src/sass/*.scss', 'src/sass/*.sass'])
        .pipe(compass({
            css: 'www/css',
            sass: 'src/sass',
            image: 'src/img'
        }))
        .on('error', function(error) {
            gutil.log('Sass Compile Error', error)
        })
        .pipe(csso())
        .pipe(gulp.dest('www/css'));
})
