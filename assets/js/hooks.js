let Hooks = {};

Hooks.MessageForm = {
  mounted() {
    this.el.addEventListener("submit", (e) => {
      setTimeout(() => {
        // hack for clearing the input after form submission
        input = document.getElementById("message_input");
        input.value = "";
      }, 10);
    });
  }
}

export default Hooks;