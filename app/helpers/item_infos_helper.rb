module ItemInfosHelper
  ##
  # Returns a hash containing for the item at itemid, including localized info
  ##
  # @param [integer] itemid
  def ItemInfosHelper.getitem(itemid)
    item_info = ItemInfo.find(itemid, :select => "id, price, supplymax, supplyrate, multiplier")
    item_locs = ItemLoc.where("item_info_id = ?",
                              item_info.id).select("id, item_info_id, locale, localized_name, localized_desc")
    item_info = item_info.as_json
    item_info['locale_info'] = item_locs.as_json
    return item_info
  end

  ##
  # Returns a hash containing for the item at itemid with locale specific info flattened
  # into the structure
  ##
  # @param [integer] itemid
  # @param [string] locale
  def ItemInfosHelper.getitembylocale(itemid, locale)

    item_info = ItemInfosHelper.getitem(itemid)
    locale_info = item_info['locale_info'].select {
                    |loc| (loc['locale'].casecmp locale) == 0
                  }
    item_info.except!('locale_info').merge!(locale_info.first.as_json.except!('id', 'item_info_id'))
    return item_info
  end

end

