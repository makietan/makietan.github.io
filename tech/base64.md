# Base64エンコードとデコード

<div class="base64-tool-container">
  <style>
    /* Markdown側のスタイルを壊さないように固有のクラス名を使用 */
    .base64-tool-container {
      max-width: 100%;
      margin: 1.5em 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      background: #f9fafb;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 20px;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }
    .base64-header {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      margin-bottom: 12px;
    }
    .base64-toggle-label {
      display: flex;
      align-items: center;
      gap: 10px;
      font-weight: 600;
      color: #4b5563;
      cursor: pointer;
      font-size: 0.9em;
      user-select: none;
    }
    .base64-textarea {
      width: 100%;
      box-sizing: border-box;
      padding: 12px;
      margin-bottom: 12px;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
      font-size: 14px;
      resize: vertical;
      background: #ffffff;
      color: #1f2937;
      transition: border-color 0.2s;
    }
    .base64-textarea:focus {
      outline: none;
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
    }
    .base64-label {
      display: block;
      margin-bottom: 6px;
      font-weight: bold;
      color: #374151;
      font-size: 0.9em;
    }
    /* トグルスイッチのCSS */
    .base64-switch {
      position: relative;
      display: inline-block;
      width: 44px;
      height: 24px;
    }
    .base64-switch input {
      opacity: 0;
      width: 0;
      height: 0;
    }
    .base64-slider {
      position: absolute;
      top: 0; left: 0; right: 0; bottom: 0;
      background-color: #3b82f6;
      border-radius: 24px;
      transition: 0.3s;
    }
    .base64-slider:before {
      position: absolute;
      content: "";
      height: 18px;
      width: 18px;
      left: 3px;
      bottom: 3px;
      background-color: white;
      border-radius: 50%;
      transition: 0.3s;
    }
    .base64-switch input:checked + .base64-slider {
      background-color: #10b981; /* デコード時は緑色に */
    }
    .base64-switch input:checked + .base64-slider:before {
      transform: translateX(20px);
    }
  </style>

  <div class="base64-header">
    <label class="base64-toggle-label">
      <span id="base64-mode-text">エンコード</span>
      <div class="base64-switch">
        <input type="checkbox" id="base64-decode-cb">
        <span class="base64-slider"></span>
      </div>
    </label>
  </div>

  <label class="base64-label">入力</label>
  <textarea id="base64-input" class="base64-textarea" rows="4" placeholder="テキストを入力してください..."></textarea>

  <label class="base64-label">出力</label>
  <textarea id="base64-output" class="base64-textarea" rows="4" readonly placeholder="結果がここに表示されます..." style="background-color: #f3f4f6;"></textarea>

  <script>
    // 即時関数で囲んで、Markdown内の他のスクリプトとの変数競合を防ぐ
    (function() {
      function encodeBase64(str) {
        try {
          const bytes = new TextEncoder().encode(str);
          return btoa(String.fromCharCode(...bytes));
        } catch (e) {
          return "";
        }
      }
      
      function decodeBase64(base64) {
        try {
          const bytes = Uint8Array.from(atob(base64), c => c.charCodeAt(0));
          return new TextDecoder().decode(bytes);
        } catch (e) {
          return "⚠️ エラー: 有効なBase64文字列ではありません";
        }
      }
      
      const inputEl = document.getElementById("base64-input");
      const outputEl = document.getElementById("base64-output");
      const decodeCb = document.getElementById("base64-decode-cb");
      const modeText = document.getElementById("base64-mode-text");
      const params = new URLSearchParams(window.location.search);

      inputEl.value = params.get("input") || "";
      decodeCb.checked = params.get("type") === "decode";

      function update() {
        const input = inputEl.value;
        if (!input) {
          outputEl.value = "";
          return;
        }
        
        if (decodeCb.checked) {
          modeText.textContent = "デコード";
          outputEl.value = decodeBase64(input);
        } else {
          modeText.textContent = "エンコード";
          outputEl.value = encodeBase64(input);
        }
      }

      inputEl.addEventListener("input", update);
      decodeCb.addEventListener("change", update);
      update();
    })();
  </script>
</div>
