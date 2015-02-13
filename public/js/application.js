$(document).ready(function() {

    // SHOW MORE SKELETON (will load more movies when there are more than 12)
    // $.ajax({
    //     url: '/path/to/file',
    //     type: 'default GET (Other values: POST)',
    //     data: {param1: 'value1'},
    // })
    // .done(function() {
    //     console.log("success");
    // });

    //AJAX CALL TO APPEND ALL NAVS
    $(".navbar-nav").on('click', 'a', function(event){
        event.preventDefault();
        var $info = $(event.target)
        console.log($info)
        $.ajax({
            url: $info.attr("href"),
            type: 'GET',
        })
        .done(function(response) {
            var $movies = $(response)[23]
            $('.movie-collection').fadeOut('slow');
            $('.movie-collection').remove();
            $('.jumbotron').append($movies);
        });
    });

    // AJAX CALL TO ADD TO FAVORITES
    $(".fav").on('submit', (function(event) {
        event.preventDefault();
        $form = $(event.target);
        console.log($form)
        $.ajax({
            url: $form.attr('action'),
            type: 'put',
            dataType: 'html',
            data: $form.serialize()
        }).done(function(response) {
            if ($form.children('button').hasClass("favorite_button") === true) {
                $form.parent('div').append('<form class="unfav" action=' +'"'+ $form.attr('action') +'"'+ '                           method="POST">'
                                            + '<input type="hidden" name="_method" value="PUT">'
                                            + '<input type="hidden" name="movie[favorite]" value="false">'
                                            + '<button class="favorited_button" type="submit" style="border: 0; background: transparent">'
                                            + '<img class="tomato"src="/tomato_icon.png">'
                                            + '</button>'
                                            + '</form>');
                $form.remove();
            };
        });
    }));

    // AJAX CALL TO REMOVE FROM FAVORITES
    $(".unfav").on('submit', (function(event) {
        event.preventDefault();
        $form = $(event.target);
        console.log($form)
        $.ajax({
            url: $form.attr('action'),
            type: 'put',
            dataType: 'html',
            data: $form.serialize()
        }).done(function(response) {
            if ($form.children('button').hasClass("favorited_button") === true) {
                $form.parent('div').append('<form class="fav" action=' +'"'+ $form.attr('action') +'"'+ '                           method="POST">'
                                            + '<input type="hidden" name="_method" value="PUT">'
                                            + '<input type="hidden" name="movie[favorite]" value="false">'
                                            + '<button class="favorited_button" type="submit" style="border: 0; background: transparent">'
                                            + '<img class="tomato"src="/non_tomato_icon.png">'
                                            + '</button>'
                                            + '</form>');
                $form.remove();
            };
        });
    }));



});

//////////////////////////////
//   INITAL API AJAX CALL   //
//////////////////////////////

// I ended up not using this because if possible
// I feel that API calls should be done by the backend
// the amount of data that was being pulled in also
// seemed to big for the front end to be responsible for it

// var apikey = "vymecugmgctsrxbbbmztpnb9";
// var baseUrl = "http://api.rottentomatoes.com/api/public/v1.0";

// // construct the uri with our apikey
// var moviesSearchUrl = baseUrl + '/lists/movies/upcoming.json?apikey=' + apikey;
// var query = "upcoming";

// $(document).ready(function() {

//   // send off the query
//   $.ajax({
//     url: moviesSearchUrl + '&callback=searchCallback',
//     dataType: "jsonp",
//     success: searchCallback

//   });
// });

// // callback for when we get back the results
// function searchCallback(data) {
//  var movies = data.movies;
//  console.log(data.movies);
//  $.each(movies, function(index, movie) {
//    $(document.body).append('<div class="container"><h3>' + movie.title + '</h3>' +
//                           // '<h1>' + movie.year + '</h1>' +
//                           // '<h1>' + movie.mpaa_rating + '</h1>' +
//                           // '<p>' + movie.synopsis + '</p>' +
//                           '<img src="' + movie.posters.thumbnail + '" /></div>');

//  });
// }