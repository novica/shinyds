// Designsystemet Shiny Input Bindings
// =====================================

// The @digdir/designsystemet-web UMD bundle assigns auto-generated IDs like
// ":ds:1" to elements that have no id (e.g. <legend> inside <fieldset>).
// These IDs are then picked up by Shiny as phantom inputs. Block them before
// they reach the server. The R-side handler in zzz.R is a safety net.
$(document).on('shiny:inputchanged', function(e) {
  if (!e.name || e.name.charAt(0) === ':') {
    e.preventDefault();
  }
});

// ============= Web Component Bindings =============

// Tabs binding
var dsTabsBinding = new Shiny.InputBinding();
$.extend(dsTabsBinding, {
  find: function(scope) {
    return $(scope).find('ds-tabs.ds-shiny-input');
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    var selected = el.querySelector('ds-tab[aria-selected="true"]');
    return selected ? selected.getAttribute('data-value') : null;
  },
  setValue: function(el, value) {
    var tabs = el.querySelectorAll('ds-tab');
    var panels = el.querySelectorAll('ds-tabpanel');

    tabs.forEach(function(tab) {
      var isSelected = tab.getAttribute('data-value') === value;
      tab.setAttribute('aria-selected', isSelected ? 'true' : 'false');
    });

    panels.forEach(function(panel) {
      var isActive = panel.getAttribute('data-value') === value;
      panel.hidden = !isActive;
    });
  },
  subscribe: function(el, callback) {
    $(el).on('click.dsTabsBinding', 'ds-tab', function(e) {
      // Let the web component handle the visual update, then notify Shiny
      setTimeout(function() { callback(true); }, 0);
    });
  },
  unsubscribe: function(el) {
    $(el).off('.dsTabsBinding');
  },
  receiveMessage: function(el, data) {
    if (data.selected) {
      this.setValue(el, data.selected);
      $(el).trigger('change');
    }
  }
});
Shiny.inputBindings.register(dsTabsBinding, 'designsystemet.tabs', true);

// Pagination binding
var dsPaginationBinding = new Shiny.InputBinding();
$.extend(dsPaginationBinding, {
  find: function(scope) {
    return $(scope).find('ds-pagination.ds-shiny-input');
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    return parseInt(el.getAttribute('data-current')) || 1;
  },
  setValue: function(el, value) {
    el.setAttribute('data-current', value);
  },
  subscribe: function(el, callback) {
    $(el).on('click.dsPaginationBinding', 'button, a', function(e) {
      var target = e.target.closest('button, a');
      if (!target) return;

      var page = target.value || target.getAttribute('aria-label');
      if (page && !isNaN(parseInt(page)) && parseInt(page) > 0) {
        el.setAttribute('data-current', parseInt(page));
        callback(true);
      }
    });
  },
  unsubscribe: function(el) {
    $(el).off('.dsPaginationBinding');
  },
  receiveMessage: function(el, data) {
    if (data.current) this.setValue(el, data.current);
    if (data.total) el.setAttribute('data-total', data.total);
    $(el).trigger('change');
  }
});
Shiny.inputBindings.register(dsPaginationBinding, 'designsystemet.pagination', true);

// Suggestion/Autocomplete binding
var dsSuggestionBinding = new Shiny.InputBinding();
$.extend(dsSuggestionBinding, {
  find: function(scope) {
    return $(scope).find('ds-suggestion.ds-shiny-input');
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    var input = el.querySelector('input');
    return input ? input.value : null;
  },
  setValue: function(el, value) {
    var input = el.querySelector('input');
    if (input) input.value = value;
  },
  subscribe: function(el, callback) {
    $(el).on('input.dsSuggestionBinding change.dsSuggestionBinding', 'input', function() {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off('.dsSuggestionBinding');
  },
  receiveMessage: function(el, data) {
    if (data.value !== undefined) this.setValue(el, data.value);
    if (data.choices) {
      var datalist = el.querySelector('datalist');
      if (datalist) {
        datalist.innerHTML = '';
        data.choices.forEach(function(choice) {
          var option = document.createElement('option');
          option.value = choice;
          datalist.appendChild(option);
        });
      }
    }
  }
});
Shiny.inputBindings.register(dsSuggestionBinding, 'designsystemet.suggestion', true);

// ============= CSS Component Bindings =============

// Action button binding (similar to shiny's actionButton)
var dsActionButtonBinding = new Shiny.InputBinding();
$.extend(dsActionButtonBinding, {
  find: function(scope) {
    return $(scope).find('.ds-action-button');
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    return $(el).data('val') || 0;
  },
  setValue: function(el, value) {
    $(el).data('val', value);
  },
  subscribe: function(el, callback) {
    $(el).on('click.dsActionButtonBinding', function() {
      var val = $(el).data('val') || 0;
      $(el).data('val', val + 1);
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off('.dsActionButtonBinding');
  }
});
Shiny.inputBindings.register(dsActionButtonBinding, 'designsystemet.actionButton', true);

// Text input binding
var dsTextInputBinding = new Shiny.InputBinding();
$.extend(dsTextInputBinding, {
  find: function(scope) {
    return $(scope).find(
      'input.ds-shiny-input:not([type="checkbox"]):not([type="radio"]), ' +
      'textarea.ds-shiny-input'
    );
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    return el.value;
  },
  setValue: function(el, value) {
    el.value = value;
  },
  subscribe: function(el, callback) {
    $(el).on('input.dsTextInputBinding change.dsTextInputBinding', function() {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off('.dsTextInputBinding');
  },
  receiveMessage: function(el, data) {
    if (data.value !== undefined) {
      this.setValue(el, data.value);
      $(el).trigger('change');
    }
  }
});
Shiny.inputBindings.register(dsTextInputBinding, 'designsystemet.textInput', true);

// Checkbox binding
var dsCheckboxBinding = new Shiny.InputBinding();
$.extend(dsCheckboxBinding, {
  find: function(scope) {
    return $(scope).find('input.ds-shiny-input[type="checkbox"]');
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    return el.checked;
  },
  setValue: function(el, value) {
    el.checked = value;
  },
  subscribe: function(el, callback) {
    $(el).on('change.dsCheckboxBinding', function() {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off('.dsCheckboxBinding');
  },
  receiveMessage: function(el, data) {
    if (data.value !== undefined) {
      this.setValue(el, data.value);
      $(el).trigger('change');
    }
  }
});
Shiny.inputBindings.register(dsCheckboxBinding, 'designsystemet.checkbox', true);

// Select binding
var dsSelectBinding = new Shiny.InputBinding();
$.extend(dsSelectBinding, {
  find: function(scope) {
    return $(scope).find('select.ds-shiny-input');
  },
  getValue: function(el) {
    return el.value;
  },
  setValue: function(el, value) {
    el.value = value;
  },
  subscribe: function(el, callback) {
    $(el).on('change.dsSelectBinding', function() {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off('.dsSelectBinding');
  },
  receiveMessage: function(el, data) {
    if (data.choices) {
      var $el = $(el);
      $el.empty();
      var choices = data.choices;
      if (Array.isArray(choices)) {
        choices.forEach(function(choice) {
          $el.append($('<option>').val(choice).text(choice));
        });
      } else {
        Object.keys(choices).forEach(function(label) {
          $el.append($('<option>').val(choices[label]).text(label));
        });
      }
    }
    if (data.value !== undefined) {
      this.setValue(el, data.value);
    }
    $(el).trigger('change');
  }
});
Shiny.inputBindings.register(dsSelectBinding, 'designsystemet.select', true);

// Toggle group reactivity is handled via Shiny.setInputValue() in an inline
// script emitted by ds_toggle_group() — no InputBinding needed.

// ============= Dialog server-side control =============

Shiny.addCustomMessageHandler('ds_dialog_show', function(msg) {
  var el = document.getElementById(msg.id);
  if (el) el.showModal();
});

Shiny.addCustomMessageHandler('ds_dialog_hide', function(msg) {
  var el = document.getElementById(msg.id);
  if (el) el.close();
});
