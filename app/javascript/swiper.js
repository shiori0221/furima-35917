document.addEventListener("DOMContentLoaded", function(){
  if (document.getElementsByClassName("item-show")){
    var mySwiper = new Swiper('.swiper-container', {

      loop: true,

      pagination: {
        el: '.swiper-pagination',
        type: 'bullets',
        clickable: true
      },

      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
    })
  }
});