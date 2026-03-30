// クエリ文字列をパースし、{tags:[], keywords:[]}を返す
function getQueryFromInput(inputValue) {
  const query = { tags: [], keywords: [] };
  // 全角空白→半角空白、連続空白→1つ
  let val = inputValue.replace(/　/g, ' ').replace(/\s+/g, ' ').trim();
  if (!val) return query;
  val.split(' ').forEach(word => {
    const tagMatch = word.match(/^\[(.*)\]$/);
    if (tagMatch) query.tags.push(tagMatch[1]);
    else query.keywords.push(word);
  });
  return query;
}

let searchTimer = null;
let searchDataPromise = null;
let normalizedPosts = [];

function escapeHTML(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function loadSearchData() {
  if (searchDataPromise) return searchDataPromise;
  searchDataPromise = fetch('/search.json')
    .then(res => res.json())
    .then(posts => {
      normalizedPosts = posts.map(postInfo => {
        const title = String(postInfo.title || '');
        const content = String(postInfo.content || '');
        const tags = Array.isArray(postInfo.tags) ? postInfo.tags : [];
        return {
          ...postInfo,
          _searchText: (title + ' ' + content).toLowerCase(),
          _tagNames: tags.map(tag => String(tag.tagName || ''))
        };
      });
      return normalizedPosts;
    });
  return searchDataPromise;
}

function focusSearchInput() {
  const input = document.getElementById('searchInput');
  if (!input) return;
  requestAnimationFrame(() => {
    input.focus();
  });
}

function resetSearchPage() {
  const input = document.getElementById('searchInput');
  if (searchTimer) {
    clearTimeout(searchTimer);
    searchTimer = null;
  }
  const hasQuery = !!(input && input.value.trim());
  updateSearchUI(hasQuery);
  focusSearchInput();
}

function updateSearchUI(hasQuery) {
  const shell = document.getElementById('searchShell');
  const clearButton = document.getElementById('searchClearButton');
  if (shell) shell.classList.toggle('is-active', hasQuery);
  if (clearButton) clearButton.style.display = hasQuery ? 'inline-flex' : 'none';
}

function clearSearchInput() {
  const input = document.getElementById('searchInput');
  const resultsDiv = document.getElementById('results');
  if (searchTimer) {
    clearTimeout(searchTimer);
    searchTimer = null;
  }
  if (input) {
    input.value = '';
  }
  if (resultsDiv) resultsDiv.innerHTML = '';
  updateSearchUI(false);
  focusSearchInput();
}

function debouncedSearch() {
  if (searchTimer) clearTimeout(searchTimer);
  const input = document.getElementById('searchInput');
  const hasQuery = !!(input && input.value.trim());
  updateSearchUI(hasQuery);
  searchTimer = setTimeout(search, 180);
}

function isMatchingPost(postInfo, query) {
  const hasAllTags = query.tags.every(tagName => postInfo._tagNames.includes(tagName));
  if (!hasAllTags) return false;
  if (query.keywords.length === 0) return true;

  const searchableText = postInfo._searchText;
  return query.keywords.every(keyword => searchableText.includes(keyword.toLowerCase()));
}

function renderResults(resultsDiv, matchedPosts) {
  resultsDiv.innerHTML = '';
  if (!matchedPosts.length) {
    resultsDiv.innerHTML = '<p class="has-text-grey">no search result.</p>';
    return;
  }

  const resultHead = document.createElement('p');
  resultHead.className = 'is-size-7 has-text-grey mb-4';
  resultHead.textContent = `${matchedPosts.length} 件ヒット`;
  resultsDiv.appendChild(resultHead);

  const dl = document.createElement('div');
  matchedPosts.forEach(postInfo => {
    const item = document.createElement('article');
    item.style.marginBottom = '1.6rem';

    const title = document.createElement('p');
    title.className = 'mb-0';
    title.style.marginBottom = '0.22rem';
    title.innerHTML = `<a class="is-size-4" style="color:#1a0dab;" href="${postInfo.url}" target="_blank" rel="noopener noreferrer">${escapeHTML(postInfo.title || 'untitled')}</a>`;
    item.appendChild(title);

    const urlLine = document.createElement('p');
    urlLine.className = 'mb-0';
    urlLine.style.marginBottom = '0.22rem';
    urlLine.style.color = '#188038';
    urlLine.style.fontSize = '0.78rem';
    urlLine.textContent = postInfo.url || '';
    item.appendChild(urlLine);

    if (postInfo.date) {
      const meta = document.createElement('p');
      meta.className = 'mb-0';
      meta.style.marginBottom = '0.22rem';
      meta.style.color = '#80868b';
      meta.style.fontSize = '0.78rem';
      meta.textContent = `${postInfo.date.year}年${postInfo.date.month}月${postInfo.date.day}日`;
      item.appendChild(meta);
    }

    if (postInfo.content) {
      const snippet = document.createElement('p');
      snippet.className = 'mb-0';
      snippet.style.marginBottom = '0.22rem';
      snippet.style.color = '#9aa0a6';
      snippet.style.fontSize = '0.84rem';
      const shortText = postInfo.content.slice(0, 170);
      snippet.textContent = shortText + (postInfo.content.length > 170 ? '…' : '');
      item.appendChild(snippet);
    }

    dl.appendChild(item);
  });
  resultsDiv.appendChild(dl);
}

// 検索実行関数（inputのonkeyupやボタンで呼ぶ）
function search() {
  const input = document.getElementById('searchInput');
  const resultsDiv = document.getElementById('results');
  if (!input || !resultsDiv) return;

  const hasQuery = !!input.value.trim();
  updateSearchUI(hasQuery);

  if (!hasQuery) {
    resultsDiv.innerHTML = '';
    return;
  }

  const query = getQueryFromInput(input.value);
  loadSearchData().then(posts => {
    const matchedPosts = posts.filter(postInfo => isMatchingPost(postInfo, query));
    renderResults(resultsDiv, matchedPosts);
  });
}

window.addEventListener('pageshow', resetSearchPage);
document.addEventListener('DOMContentLoaded', resetSearchPage);