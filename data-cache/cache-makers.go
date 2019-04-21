package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
)

// {"attend_link":"https:\/\/makerfaireorlando.com\/attend","accepteds_count":305,"accepteds":[{"exhibit
/*
{"attend_link":"https:\/\/makerfaireorlando.com\/attend","accepteds_count":305,"accepteds":
[
	{
		"exhibit_category":"Art, Craft",
		"hidden_exhibit_category":"",
		"hidden_maker_category":"2018, Alumni",
		"project_name":"3 Fairies Workshop",
		"description":"My exhibit features my creations, which I call \"Dudes\", which are all small sculptures of various characters, from cartoons to comics to horror movies, and beyond. All of my pieces are hand sculpted, by myself, on a base of my own creation. I then make a silicone mold of each sculpture. These are then cast in a plastic resin (Smooth-Cast 320) which, once set, I then paint by hand in acrylics. \r\n\r\nOnce each sculpture is cast and painted, I spray them with a matte finish and attach them each to their own personalized backgrounds, which are small canvases that I have also painted by hand. While the molding process does make it easier to duplicate these \"Dudes,\" no two pieces are ever exactly alike, and a lot of hard work and love goes into each piece. \r\n\r\nI also feature a few truly one of a kind pieces, sculpted from polymer clay and then hand painted in acrylic paint. These are also of a few fan favorite characters.",
		"web_site":"https:\/\/www.etsy.com\/shop\/bananafairy59",
		"promo_url":"https:\/\/makerfaireorlando.com\/exhibit\/2018\/3-fairies-workshop\/",
		"qrcode_url":"",
		"project_short_summary":"Ali makes small sculptures of a few of everyone\u2019s favorite characters from pop culture, each hand made and perfect to hang on your wall and brighten up any room. She\u2019s been sculpting since she was a child, and now her favorite thing is sending her sculptures off to new homes where they\u2019ll make no just her happy, but anyone who comes across them.",
		"location":"Spirit Building",
		"photo_link":"https:\/\/makerfaireorlando.com\/wp-content\/uploads\/2018\/07\/bannerali4-300x170.jpg",
		"additional_photos":[
			{
				"thumbnail":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/30127025_1767180143302676_5401743341665000795_n-wpcf_150x150.jpg",
				"medium":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/30127025_1767180143302676_5401743341665000795_n-wpcf_300x300.jpg",
				"large":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/30127025_1767180143302676_5401743341665000795_n.jpg",
				"full":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/30127025_1767180143302676_5401743341665000795_n.jpg"
			},
			{
				"thumbnail":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/28685857_1736027669751257_9107480242004008990_n-wpcf_150x150.jpg",
				"medium":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/28685857_1736027669751257_9107480242004008990_n-wpcf_300x300.jpg",
				"large":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/28685857_1736027669751257_9107480242004008990_n.jpg",
				"full":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/28685857_1736027669751257_9107480242004008990_n.jpg"
			},
			{
				"thumbnail":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/29683160_1759573847396639_3746728557089769577_n-wpcf_150x150.jpg",
				"medium":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/29683160_1759573847396639_3746728557089769577_n-wpcf_300x300.jpg",
				"large":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/29683160_1759573847396639_3746728557089769577_n.jpg",
				"full":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/29683160_1759573847396639_3746728557089769577_n.jpg"
			},
			{
				"thumbnail":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/31357852_1788075591213131_6697306677998780770_n-wpcf_150x150.jpg",
				"medium":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/31357852_1788075591213131_6697306677998780770_n-wpcf_300x300.jpg",
				"large":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/31357852_1788075591213131_6697306677998780770_n.jpg",
				"full":"https:\/\/mfocdn-themakereffectfo.netdna-ssl.com\/wp-content\/uploads\/2018\/07\/31357852_1788075591213131_6697306677998780770_n.jpg"
			}
		],
		"embeddable_media":[""],
		"maker":{
			"name":"Ali Wagner",
			"description":"Ali makes small sculptures of a few of everyone's favorite characters from pop culture, each hand made and perfect to hang on your wall and brighten up any room. She's been sculpting since she was a child, and now her favorite thing is sending her sculptures off to new homes where they'll make no just her happy, but anyone who comes across them.",
			"photo_link":"https:\/\/makerfaireorlando.com\/wp-content\/uploads\/2018\/07\/3wanddark-300x284.png"
		}
	},

],"categories":[{"name":"07-06-2015","slug":"featured-07-06-2015","url":"https:\/\/makerfaireorlando.com\/makers\/?category=featured-07-06-2015"},


],"title":"Maker Faire Orlando","sponsor_link":"https:\/\/makerfaireorlando.com\/sponsor","volunteer_link":"https:\/\/makerfaireorlando.com\/volunteers","about_url":"https:\/\/makerfaireorlando.com\/about","info_url":"https:\/\/makerfaireorlando.com\/mobile-app-information-page","json_version":1}
*/
type makerList struct {
	AttendLink     string    `json:"attend_link"`
	AcceptedsCount int       `json:"accepteds_count"`
	Accepteds      []exhibit `json:"accepteds"`
}

type exhibit struct {
	ProjectName string `json:"project_name"`
	Description string `json:"description"`
	Website     string `json:"web_site"`
	PhotoLink   string `json:"photo_link"`
	Maker       maker  `json:"maker"`
}

type maker struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	PhotoLink   string `json:"photo_link"`
}

func main() {
	// Open our jsonFile
	jsonFile, err := os.Open("makers-json")
	// if we os.Open returns an error then handle it
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Successfully Opened json")
	// defer the closing of our jsonFile so that we can parse it later on
	defer jsonFile.Close()

	byteValue, err := ioutil.ReadAll(jsonFile)
	if err != nil {
		fmt.Println(err)
	}

	var list makerList
	err = json.Unmarshal(byteValue, &list)
	if err != nil {
		fmt.Println(err)
	}

	//fmt.Printf("%+v\n", list)

	redo, err := json.MarshalIndent(list, "", "  ")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(redo))

}
