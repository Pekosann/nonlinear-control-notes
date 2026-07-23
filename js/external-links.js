// Make links to other sites open in a new tab. Runs on every page.
// A link is "external" if its host differs from the site's host. Internal links
// (notes, tags, index) are left alone so navigation stays in the same tab.
$(function () {
  var host = window.location.hostname;
  $("#main a[href^='http']").each(function () {
    if (this.hostname && this.hostname !== host) {
      $(this)
        .attr("target", "_blank")
        // rel prevents the new tab from gaining access to this page via window.opener
        .attr("rel", "noopener noreferrer");
    }
  });
});
