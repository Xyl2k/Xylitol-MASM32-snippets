<?php
/*
SQL:
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `nom` varchar(80) NOT NULL,
  `prenom` varchar(80) NOT NULL,
  `email` varchar(80) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

INSERT INTO `users` (`user_id`, `username`, `nom`, `prenom`, `email`) VALUES
(1, 'Xylitol', 'Ano', 'Nymous', 'not disclosed'),
(2, 'Xsp!d3r', 'Ano', 'Nymous', 'not disclosed'),
(3, 'KKR', 'Ano', 'Nymous', 'not disclosed'),
(4, 'qpt', 'Ano', 'Nymous', 'not disclosed'),
(5, 'Encrypto', 'Ano', 'Nymous', 'not disclosed'),
(6, 'Mynes', 'Ano', 'Nymous', 'not disclosed');

Usage:
vulnerable.php?id=4 order by 4
vulnerable.php?id=-1+union+select+1,2,3,4,5--

*/
mysql_connect("localhost","root","");
mysql_select_db("testsqlinj");
$user_id = $_GET['id']; // $user_id = intval($_GET['id']);
$sql = mysql_query("SELECT username, nom, prenom, email FROM users WHERE user_id = $user_id") or die(mysql_error());
if(mysql_num_rows($sql) > 0)
{
$data = mysql_fetch_object($sql);
echo "
<fieldset>
<legend>Profile de ".$data->username."</legend>
<p>Nom d'utilisateur : ".$data->username."</p>
<p>Nom et prénom : ".$data->nom." " .$data->prenom ."</p>
<p>Adresse email : ".$data->email."</p>
</fieldset>";
}
?>