function double_range(parent, min, max, step, width, min_display, max_display) {

  this.min_limit = min;
  this.max_limit = max;

  /*return current minimum value - this slider goes right-to-left, so calculate value*/
  this.min = () => {
    return min_range.max - min_range.value + parseInt(min_range.min);
  }

  /*return current maximum value*/
  this.max = () => {
    return max_range.value;
  }

  /*update widths of sliders so the one the user is interacting with is as wide as possible*/
  const update_double_range_widths = () => {
    /*SIZE is how many pixels for each number on slider*/
    const SIZE = width / (max - min);
    /*set width of minimum slider - if either end is 0 make it 16 to give it room to display*/
    if (min_range.min == min_range.max) {
      min_range.style.width = "16px";
    } else if (max_range.min == max_range.max) {
      min_range.style.width = (width - 16) + "px";
    } else {
      min_range.style.width = Math.floor((min_range.max - min_range.min) * SIZE) + "px";
    }
    /*set width of maximum slider - total width minus width of minium slider*/
    max_range.style.width = (width - parseInt(min_range.style.width)) + "px";
  }

  /*if object was passed output display elements, update them*/
  const update_double_range_values = () => {
    if (min_display) {
      min_display.textContent = this.min();
    }
    if (max_display) {
      max_display.textContent = this.max();
    }
  };

  /*add min limit label*/
  let min_limit = document.createElement("span");
  min_limit.textContent = min;
  parent.appendChild(min_limit);

  /*add minimum slider*/
  let min_range = document.createElement("input");
  min_range.type = "range";
  min_range.min = min;
  min_range.max = max;
  min_range.value = max;
  min_range.step = step;
  min_range.style.direction = "rtl";
  min_range.style.marginRight = 0;
  parent.appendChild(min_range);
  /*keep all elements of double range slider together - don't wrap*/
  parent.style.display = "flex";

  /*add maximum slider*/
  let max_range = document.createElement("input");
  max_range.type = "range";
  max_range.min = max;
  max_range.max = max;
  max_range.step = step;
  max_range.style.marginLeft = 0;
  parent.appendChild(max_range);

  /*add max limit label*/
  let max_limit = document.createElement("span");
  max_limit.textContent = max;
  parent.appendChild(max_limit);

  /*when user clicks on minimum slider, update slider widths*/
  min_range.addEventListener("mousedown", () => {
    /*keep previous min_range.max to work out new min_range.value*/
    let previous_max = min_range.max;
    /*make minimum slider end right before maximum value*/
    min_range.max = max_range.value;
    max_range.min = min_range.max;
    /*work out new min_range.value*/
    min_range.value = min_range.max - previous_max + parseInt(min_range.value);
    update_double_range_widths();
  });

  /*when user clicks on maximum slider, update slider widths*/
  max_range.addEventListener("mousedown", () => {
    /*make maximum slider start right after minimum value*/
    max_range.min = this.min();
    min_range.max = max_range.min;
    min_range.value = min_range.min;
    update_double_range_widths();
  });

  /*when user chooses new value, update the output values and fire the "input" event*/
  min_range.addEventListener("input", () => {
    update_double_range_values();
    parent.dispatchEvent(new Event("input"));
  });

  /*when user chooses new value, update the output values and fire the "input" event*/
  max_range.addEventListener("input", () => {
    update_double_range_values();
    parent.dispatchEvent(new Event("input"));
  });

  /*initialise widths and values*/
  update_double_range_widths();
  update_double_range_values();
}