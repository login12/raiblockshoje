<?php  
  $url = "https://bitpay.com/api/rates";

  $json = file_get_contents($url);
  $data = json_decode($json, TRUE);

  $rate = $data[1]["rate"];    
  $usd_price = 10;     # Let cost of elephant be 10$
  $bitcoin_price = round( $usd_price / $rate , 8 );
?>

<ul>
   <li>Price: <?=$usd_price ?> $ / <?=$bitcoin_price ?> BTC
</ul>
