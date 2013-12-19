part of turn;

/**
 * Basic asset loading (work in progress)
 * @TODO: Move to separate 'data' file(s)?
 */
List assetList = new List<String>();

Map gCachedAssets = {};

// Does callback function even work in dart?
void loadAssets(List assetList, callbackFcn) {
  //window.console.log('hello');
  Map loadBatch = {
    'count': 0,
    'total': assetList.length,
    'cb': callbackFcn,
    };
  //window.console.log(loadBatch);

  for (int i = 0; i < assetList.length; i++) { // for(each)?
    String assetName = assetList[i];
    // Check if the given assetname exists in the cache gCachedAssets.
    if (gCachedAssets[assetName] == null) {
      // Load the asset and save it to cache
      ImageElement img = new ImageElement();
      img.onLoad.listen((Event e) {
        onLoadedCallback(img, loadBatch);
      });
      img.src = assetName;
      gCachedAssets[assetName] = img;
    }
    else {
      // Load the cached asset
      onLoadedCallback(gCachedAssets[assetName], loadBatch);
    }
  }
}

void onLoadedCallback(ImageElement asset, Map batch) {
  // If the entire batch has been loaded call the callback
  batch['count']++;
  if (batch['count'] == batch['total']) {
    batch['cb'](asset);
  }
}
