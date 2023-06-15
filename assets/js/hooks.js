let Hooks = {};

Hooks.MessageForm = {
  mounted() {
    this.el.addEventListener("submit", (e) => {
      e.preventDefault();
      e.stopPropagation();
      this.el.reset()
    });
  },
}

export default Hooks;