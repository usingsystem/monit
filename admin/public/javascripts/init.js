/*jquery hoverClass plugin*/
(function($){
  $.fn.hoverClass = function(c, block_fn){
    return this.each(function(){
      $(this).hover(
        function() { if(!$.isFunction(block_fn) || block_fn.call(this))$(this).addClass(c); },
        function() { if(!$.isFunction(block_fn) || block_fn.call(this))$(this).removeClass(c); }
      );
    });
  }; 

  function _s_or_h(el){
    //el = $(el);
    var t = el.attr('alt'), re = t ? $(t) : [];
    el.length && re.length && re[el[0].checked ? "show" : "hide"]();
  }
  $.fn.checkTrigger = function(){
    return this.each(function(){
      var s = $(this), rel = s.attr("rel"), rel = rel ? $(rel) : [];
      _s_or_h(s);
      s.add(rel).click(function(){
        _s_or_h(s);
      });
    });
  }; 

  /*build form ui*/

  $(function(){
    $(".button-wrap").hoverClass("button-hover");
    $(".form, .select-form").submit(function(){
      if(this.hasSubmit) return false;
      $(this).find("input:submit").attr("disabled", "disabled").parent().addClass("button-disabled");
      this.hasSubmit = true;
    }).each(function(){
      $(this).find("input:submit").attr("disabled", null).parent().removeClass("button-disabled");
    });
    $(".check-trigger").checkTrigger();
  });

  /*filters action*/
  $(function(){
    var filters = $('.filters form');
    filters.find("select").change(function(){
      $(this).parents("form").submit();
    });
    //filters.find(".actions").hide();
  });

  /*grid*/
  $(function(){
    var select_all = $(".grid thead .actions input:checkbox");
    var ids = $(".grid tbody .actions input:checkbox");
    var mult_actions = $(".grid thead .actions .pop");
    function action_display(){
      mult_actions[ids.filter(":checked").size() ? "show" : "hide"]();
    }
    select_all.click(function(){
      var checked = this.checked;
      ids.each(function(){
        this.checked = checked;
      });
      action_display();
    });
    ids.click(function(){
      action_display();
    });
    mult_actions.find("a").click(function(){
      $(this).parents("form:first").attr("action", this.href).submit();
      return false;
    });
    action_display();
    $(".grid tbody tr").hoverClass("hover");
  });
  /*selector*/
  $(function(){
    $(".selector").scrollTo('a.selected');
  });

})(jQuery);
