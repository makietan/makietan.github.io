class TableSort {
    constructor() {
        this.load();
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
        const rows = [...table.querySelectorAll('tr')];
        rows.shift();
        rows.sort((a, b) => {
            const aVal = a.children[index].innerText;
            const bVal = b.children[index].innerText;
            return aVal > bVal ? 1 : -1;
        });
        rows.forEach(row => {
            table.appendChild(row);
        });
    }
};

window.addEventListener('load', () => {
    new TableSort();
});