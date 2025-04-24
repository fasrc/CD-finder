var gulp = require('gulp');
const sass = require('gulp-sass')(require('sass'));
// var autoprefixer = require('gulp-autoprefixer');
var bs = require('browser-sync').create();
var plumber = require('gulp-plumber');

gulp.task('sass', function () {
    return gulp.src('sass/*.scss')
	    .pipe(plumber())
	    .pipe(sass())
        // .pipe(autoprefixer({
        //     browsers: ['last 4 versions'],
        //     cascade: false
        // }))
	    .pipe(gulp.dest('css'))
	    .pipe(bs.stream());
});

gulp.task('browser-sync', gulp.series('sass', function() {
    bs.init({
        proxy: "http://modularstorage.test/finder"
    });
}));


gulp.task('watch', gulp.series('browser-sync', function () {
    gulp.watch("sass/*.scss", ['sass']);

    // gulp.watch("**/*.php").on('change', bs.reload);
    gulp.watch("**/*.css").on(['add', 'change'], bs.reload);

}));

gulp.task('default', gulp.series('sass', 'watch'));