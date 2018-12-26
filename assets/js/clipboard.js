window.onload = () => {
  [...document.querySelectorAll('.clipboard')].forEach((e) => {
    e.addEventListener("click", () => {
      if (!copy(e.dataset.clipboard)) {
        console.error('clipboard error');
      }
    });
  });
};

const copy = (string) => {
  var tmp = document.createElement('div');
  tmp.appendChild(document.createElement('pre')).textContent = string;
  var style = tmp.style;
  style.position = 'fixed';
  style.left = '-100%';
  document.body.appendChild(tmp);
  document.getSelection().selectAllChildren(tmp);
  var result = document.execCommand('copy');
  document.body.removeChild(tmp);
  return result;
}
