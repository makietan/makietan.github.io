function collapse(element, selector) {
  console.log(element);
  console.log(selector);
  var obj = document.querySelector(selector);
  if (obj.style.display == "inline-block") {
    element.style.display = "inline-block";
    obj.style.display = "none";
  } else {
    element.style.display = "none";
    obj.style.display = "inline-block";
  }
}