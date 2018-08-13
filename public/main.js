let closeButton = document.querySelector('.close-button');
let flashMsg = document.querySelector('.flash');

closeButton.addEventListener('click',(event)=>{
    flashMsg.addClass('hide');
})