function hide_image() {
  [...document.querySelectorAll('.card__image > img')].forEach((e) => {
    e.addEventListener('error', () => {
      e.style.display = 'none';
      e.parentElement.style.display = 'none';
      e.parentElement.parentElement.querySelector('.card__title').style.left = '8px';
      e.parentElement.parentElement.querySelector('.card__description').style.left = '8px';
      e.parentElement.parentElement.querySelector('.card__header').style.left = '8px';
    });
  });
}
document.addEventListener("DOMContentLoaded", (event) => hide_image());