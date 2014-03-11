var currentpage = 1;


$(window).scroll(function() {
   if($(window).scrollTop() + $(window).height() == $(document).height()) {

                                  var url = window.location;
                                  if (url == ('http://'+location.host+'/'))
                                  {
                                      url+= 'posts';
                                  }
                                    $.ajax({
                                    type: "GET",
                                    dataType: "script",
                                    cache: false,
                                    url: url+'.js?page='+currentpage,
                                    });  
                                  currentpage++;
 }   
});