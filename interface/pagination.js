/*
This function creates paginators in a document - there can be multiple paginators which stay in sync.
Use it by passing a collection of parent elements for the paginators, and the number of pages.
This example puts a paginator for 150 pages in each element with class "div_paginator".
pagination(document.querySelectorAll(".div_paginator"), 150);
When the page changes the paginator dispatches a "pagination_update" event - the selected page is in the event detail.
document.addEventListener("pagination_update", function(e) {
	alert(e.detail.selected);
}
*/
function pagination(parents, total_pages) {

	/*create paginator for each parent*/
	for (let parent of parents) {
		parent.textContent = "";
		
		let table = document.createElement("table");
		table.className = "paginator";
		parent.appendChild(table);

		let tr = document.createElement("tr");
		table.appendChild(tr);

		/*first cell has left arrow*/
		let td = document.createElement("td");
		td.textContent = "<";
		tr.appendChild(td);

		/*second cell has page 1*/
		td = document.createElement("td");
		td.textContent = 1;
		tr.appendChild(td);

		/*create a cell for each page, to a maximum of 13*/
		for (let i = 2; i <= Math.min(total_pages - 1, 13); i++) {
			td = document.createElement("td");
			tr.appendChild(td);
		}

		/*if there's more than one page, second to last cell has last page*/
		if (total_pages > 1) {
			td = document.createElement("td");
			td.textContent = total_pages;
			tr.appendChild(td);
		}

		/*last cell has right arrow*/
		td = document.createElement("td");
		td.textContent = ">";
		tr.appendChild(td);

		/*if user clicks inside row, dispatch a "pagination_update" event*/
		tr.addEventListener("click", function(e) {
			/*only dispatch event if this is an enabled cell*/
			if (e.target.className == "enabled") {
				/*get all cells in row*/
				let tds = this.querySelectorAll("td");
				/*find current selected page*/
				let selected = parseInt(this.querySelector(".selected").textContent);
				/*page will be the new selected page*/
				let page = 1;
				/*page_after_previous_truncation will be the page number immediately following the ... trunctation in cell 2*/
				/*if it's null, there is no truncation in cell 2*/
				let page_after_previous_truncation = null;

				/*if page number was clicked go to that page*/
				if (parseInt(e.target.textContent)) {
					page = parseInt(e.target.textContent);
					/*if first or last page wasn't clicked and "previous" truncation is present, include current "previous" truncation*/
					if (page > 1 && page < total_pages && tds[2].textContent == "...") {
						page_after_previous_truncation = parseInt(tds[3].textContent);
					/*if final page number was clicked and there are more than 14 pages, include "previous" truncation*/
					} else if (page == total_pages && total_pages > 14) {
						page_after_previous_truncation = total_pages - 11;
					}
				/*if left arrow was clicked*/
				} else if (e.target.textContent == "<") {
					/*go to previous page*/
					page = selected - 1;
					/*if we're moving onto "previous" truncation*/
					if (this.querySelector(".selected").previousElementSibling.textContent == "...") {
						/*if we can't fit in remaining cells, go back 10 pages*/
						if (parseInt(tds[3].textContent) > 13) {
							page_after_previous_truncation = parseInt(tds[3].textContent) - 10;
						}
					/*if we're not moving onto "previous" truncation and "previous" truncation is present, include current "previous" truncation*/
					} else if (tds[2].textContent == "...") {
						page_after_previous_truncation = parseInt(tds[3].textContent);
					}
				/*if right arrow was clicked*/
				} else if (e.target.textContent == ">") {
					/*go to next page*/
					page = selected + 1;
					/*if we're moving onto "next" truncation*/
					if (this.querySelector(".selected").nextElementSibling.textContent == "...") {
						/*if we can't fit in remaining cells, go forward 10 pages*/
						if (parseInt(tds[3].textContent) < total_pages - 21) {
							page_after_previous_truncation = parseInt(tds[3].textContent) + 10;
						/*if we can fit in remaining cells, go to last pages*/
						} else {
							page_after_previous_truncation = total_pages - 11;
						}
					/*if we're not moving onto "next" truncation and "previous" truncation is present, include current "previous" truncation*/
					} else if (tds[2].textContent == "...") {
						page_after_previous_truncation = parseInt(tds[3].textContent);
					}
				/*if "previous" truncation was clicked*/
				} else if (e.target == tds[2] && e.target.textContent == "...") {
					/*if we can fit in remaining cells without "previous" truncation*/
					if (tds[3].textContent <= 13) {
						page = 12;
					/*if we can't fit in remaining cells, go back 10 pages*/
					} else {
						page = parseInt(tds[3].textContent) - 1;
						page_after_previous_truncation = page - 9;
					}
				/*if "next" truncation was clicked*/
				} else if (e.target == tds[13] && e.target.textContent == "...") {
					/*if we can fit in remaining cells without "next" truncation*/
					if (tds[3].textContent >= total_pages - 21) {
						page = total_pages - 11;
						page_after_previous_truncation = page;
					/*if we can't fit in remaining cells, go forward 10 pages*/
					} else {
						page = parseInt(tds[3].textContent) + 10;
						page_after_previous_truncation = page;
					}
				}

				e.target.dispatchEvent(new CustomEvent("pagination_update", {bubbles: true, detail: {selected: page, page_after_previous_truncation: page_after_previous_truncation}}));
			}
		});

		/*if there's a "pagination_update" event, update this paginator*/
		document.addEventListener("pagination_update", function(e) {
			let tds = parent.querySelectorAll("td");
			/*if page after "previous" truncation is specified*/
			if (e.detail.page_after_previous_truncation) {
				/*add "previous" truncation*/
				tds[2].textContent = "...";
				/*fill in page numbers*/
				for (let i = 0; i < 10; i++) {
					tds[i + 3].textContent = e.detail.page_after_previous_truncation + i; 
				}
				/*if "next" truncation is not necessary, add page number before final page*/
				if (e.detail.page_after_previous_truncation == total_pages - 11) {
					tds[tds.length - 3].textContent = total_pages - 1;
				/*otherwise include "next" truncation*/
				} else {
					tds[tds.length - 3].textContent = "...";
				}
			/*if there's no "previous" truncation and there are more than 14 pages, add "next" truncation*/
			} else if (total_pages > 14) {
				for (let i = 2; i < tds.length - 3; i++) {
					tds[i].textContent = i;
				}
				tds[13].textContent = "...";
			/*if there's no "previous" truncation and there are between 3 and 14 pages, put page numbers in cells*/
			} else if (total_pages >= 3 && total_pages <= 14) {
				for (let i = 2; i < tds.length - 2; i++) {
					tds[i].textContent = i;
				}				
			}

			/*enable all cells*/
			for (let td of tds) {
				if (parseInt(td.textContent) == e.detail.selected) {
					td.className = "selected";
				} else {
					td.className = "enabled";
				}
			}
			/*if first page is selected, disable "previous" button*/
			if (e.detail.selected == 1) {
				tds[0].className = "disabled";
			}
			/*if last page is selected, disable "next" button*/
			if (e.detail.selected == total_pages) {
				tds[tds.length - 1].className = "disabled";
			}
		});
	}

	let stylesheet = document.head.appendChild(document.createElement("style")).sheet;
	stylesheet.insertRule(".paginator {margin: 1em auto; border-collapse: collapse;}");
	stylesheet.insertRule(".paginator td {border: 1px solid lightgrey; padding: 1em; width: 2em; text-align: center; font-size: 0.8em; user-select: none;}");
	stylesheet.insertRule(".paginator td.enabled:hover {cursor: pointer; background-color: lightgrey;}");
	stylesheet.insertRule(".paginator td.disabled {color: grey;}");
	stylesheet.insertRule(".paginator td.selected {background-color: grey; color: white;");

	/*set paginators to initial values*/
	parents[0].querySelector("td").dispatchEvent(new CustomEvent("pagination_update", {bubbles: true, detail: {selected: 1, page_after_previous_truncation: null}}));
}