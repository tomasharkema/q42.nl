function hackyReplaceAssetsUrl(str) {
  // XXX: Use Spacebars for this instead
  return str.replace("{{assetsUrl}}", Utils.getStaticAssetsUrl());
}

Template.thing.onCreated(function() {
  this.thingId = Template.currentData().id;
  this.autorun( () => this.subscribe("things", [this.thingId]) );
});

Template.thing.helpers({
  thing() {
    let thing = Things.findOne({name: Template.instance().thingId});
    if (thing) {
      if (thing.content_en)
        thing.content_en = hackyReplaceAssetsUrl(thing.content_en);
      return thing;
    }
  }
});

Template.group.onCreated(function() {
  this.thingIds = Template.currentData().ids.split(",");
  this.autorun( () => this.subscribe("things", this.thingIds) );
});

Template.group.helpers({
  things() {
    let things = Things.find({name: {$in: Template.instance().thingIds}}).fetch();
    return things.map((thing) => {
      if (thing.content_en)
        thing.content_en = hackyReplaceAssetsUrl(thing.content_en);
      return thing;
    });
  }
});
