class TableSort {
    constructor() {
        this.load();
        this.orders = {};
    }

    load() {
        this.tables = [...document.querySelectorAll('table')];
        this.tables.forEach(table => {
            this.addSortButton(table);
        });
    }

    addSortButton(table) {
        const headers = [...table.querySelectorAll('th')];
        headers.forEach(header => {
            header.addEventListener('click', () => {
                this.sortTable(table, header);
            });
        });
    }

    sortTable(table, header) {
        const index = [...header.parentElement.children].indexOf(header);
        const order = this.orders[index] || 'asc';
        const rows = [...table.querySelectorAll('tr')];
        rows.shift();
        rows.sort((a, b) => {
            const aVal = a.children[index].innerText;
            const bVal = b.children[index].innerText;
            if (order === 'asc') {
                return aVal > bVal ? 1 : -1;
            } else {
                return aVal < bVal ? 1 : -1;
            }
        });
        rows.forEach(row => {
            table.appendChild(row);
        });
    }
};

window.addEventListener('load', () => {
    new TableSort();
});