# coding: UTF-8

module CategoriesHelper

  def side_ad  
    ad = <<-EOD
<div class="ad">

<script type="text/javascript"><!--
google_ad_client = "ca-pub-5201610535198508";
/* Batonサイド */
google_ad_slot = "6334972684";
google_ad_width = 160;
google_ad_height = 600;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>

</div>
    EOD
    return ad.html_safe
  end

  def header_ad
    ad = <<-EOD
<div class="ad">

<script type="text/javascript"><!--
google_ad_client = "ca-pub-5201610535198508";
/* Batonヘッダー */
google_ad_slot = "7811705887";
google_ad_width = 336;
google_ad_height = 280;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>

</div>
    EOD
    return ad.html_safe
  end

  def footer_ad
    ad = <<-EOD
<div class="ad">

<script type="text/javascript"><!--
google_ad_client = "ca-pub-5201610535198508";
/* Batonフッター */
google_ad_slot = "3381506289";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>

</div>
    EOD
    return ad.html_safe
  end

end
