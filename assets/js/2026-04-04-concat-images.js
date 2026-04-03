class LinkImageHorizontally {


  constructor(fileInputId, buttonId, resultId) {
    this.fileInput = document.getElementById(fileInputId);
    this.button = document.getElementById(buttonId);
    this.result = document.getElementById(resultId);

    this.button.addEventListener('click', () => this.concatImages());
  }

  async concatImages() {
    const files = Array.from(this.fileInput.files);
    if (files.length === 0) {
      alert('画像ファイルを選択してください。');
      return;
    }

    const images = await Promise.all(files.map(file => this.loadImage(file)));
    const totalWidth = images.reduce((sum, img) => sum + img.width, 0);
    const maxHeight = Math.max(...images.map(img => img.height));

    const canvas = document.createElement('canvas');
    canvas.width = totalWidth;
    canvas.height = maxHeight;
    const ctx = canvas.getContext('2d');

    let xOffset = 0;
    for (const img of images) {
      ctx.drawImage(img, xOffset, 0);
      xOffset += img.width;
    }

    const resultImg = new Image();
    resultImg.src = canvas.toDataURL('image/png');
    this.result.innerHTML = '';
    this.result.appendChild(resultImg);
  }

  loadImage(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = (event) => {
        const img = new Image();
        img.onload = () => resolve(img);
        img.src = event.target.result;
      };
      reader.onerror = (error) => reject(error);
      reader.readAsDataURL(file);
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new LinkImageHorizontally('file-input', 'concat-button', 'result');
});
