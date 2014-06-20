var gulp       = require('gulp'),
    livereload = require('gulp-livereload'),
    config     = require('../config'),
    gutil      = require('gulp-util');

gulp.task('watch', function() {
    var server = livereload();
    var reload = function(file) {
        server.changed(file.path);
    }
    gulp.watch('src/coffee/**/*.coffee', ['coffee']);
    gulp.watch(['src/sass/*.scss', 'src/sass/*.sass'], ['compass']);
    gulp.watch('src/jade/*.jade', ['jade']);
    gulp.watch('src/img/*', ['images']);
    gulp.watch('www/**').on('change', function(file) {
        gutil.log('File Changed', file.path);
        server.changed(file.path);
    });
});
