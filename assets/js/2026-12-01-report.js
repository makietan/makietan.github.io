document.addEventListener('DOMContentLoaded', () => {
  const browser = document.querySelector('#route-browser');
  if (!browser) return;

  let list = browser.nextElementSibling;
  while (list && list.tagName !== 'UL') list = list.nextElementSibling;
  if (!list) return;

  const parseMinutes = (text) => {
    const match = text.match(/(?:(\d+)時間)?(\d+)分/);
    return match ? Number(match[1] || 0) * 60 + Number(match[2]) : null;
  };

  const routes = [...list.querySelectorAll(':scope > li')].map((item, index) => {
    const summary = item.querySelector(':scope > p')?.textContent || item.textContent;
    const details = item.querySelector('details')?.textContent || '';
    const fare = summary.match(/([\d,]+)円/);
    const walk = summary.match(/徒歩(\d+)分/);
    const transfers = details.match(/乗換回数：(\d+)回/);

    return {
      item,
      index,
      name: summary.split(/[：:]/, 1)[0].trim(),
      fare: fare ? Number(fare[1].replace(/,/g, '')) : null,
      duration: parseMinutes(summary),
      walk: walk ? Number(walk[1]) : null,
      transfers: transfers ? Number(transfers[1]) : null,
      details
    };
  });

  const filters = [...browser.querySelectorAll('[data-filter]')];
  const sort = browser.querySelector('[data-sort]');
  const direction = browser.querySelector('[data-direction]');
  const count = browser.querySelector('[data-result-count]');
  const modeFilters = [...browser.querySelectorAll('.route-browser__modes input')];

  const update = () => {
    const activeModes = modeFilters.filter((input) => input.checked).map((input) => input.value);
    const visibleRoutes = routes.filter((route) => {
      const nameFilter = browser.querySelector('[data-filter="name"]').value.trim().toLocaleLowerCase();
      if (nameFilter && !route.name.toLocaleLowerCase().includes(nameFilter)) return false;

      for (const key of ['fare', 'duration', 'walk', 'transfers']) {
        const value = browser.querySelector(`[data-filter="${key}"]`).value;
        if (value !== '' && (route[key] === null || route[key] > Number(value))) return false;
      }

      return activeModes.length === 0 || activeModes.some((mode) => route.details.includes(mode));
    });

    const key = sort.value;
    const multiplier = direction.value === 'desc' ? -1 : 1;
    visibleRoutes.sort((left, right) => {
      const difference = (left[key] ?? Infinity) - (right[key] ?? Infinity);
      return difference === 0 ? left.index - right.index : difference * multiplier;
    });

    for (const route of routes) route.item.hidden = true;
    for (const route of visibleRoutes) {
      route.item.hidden = false;
      list.append(route.item);
    }
    count.textContent = `${visibleRoutes.length} / ${routes.length} 店舗`;
  };

  browser.addEventListener('input', update);
  browser.addEventListener('change', update);
  browser.querySelector('[data-reset]').addEventListener('click', () => {
    for (const filter of filters) filter.value = '';
    for (const input of modeFilters) input.checked = false;
    sort.value = 'fare';
    direction.value = 'asc';
    update();
  });

  update();
});