Tag.create!(name: 'ruby')
Tag.create!(name: '胡扯')
Tag.create!(name: '香港记者')
Tag.create!(name: '摄影')

Post.create!(title: "第一篇文章", content: ' 李寻欢，被称作”小李探花”，是明宪宗朱见深成化年间探花（殿试中进士榜一甲第三名）。他出身一个书香世家。李家三父子俱擅长于文墨，均在科举中高中为探花，在家乡以“老李探花”（李寻欢的父亲）、“大李探花”（李寻欢的兄长）、“小李探花”（李寻欢）闻名，李家的门上亦有御书的“一门七进士，父子三探花”对联。由于仕途得志，所以李寻欢早年已于朝廷为官。后来，由于被胡云冀上奏弹劾，以他淡泊名利的性格，终于辞官而去。后来，李寻欢投身江湖，成为首屈一指的武林人物，以飞刀神技闻名。他与林诗音彼此相爱，订下婚约，原欲结为夫妻；后来他因为知道义兄龙啸云爱上林诗音，想报恩于义兄，所以刻意纵情酒色，借故疏远林诗音，促成龙啸云与林诗音的婚姻。并在龙啸云与林诗音成亲之後，把自己的府邸和万贯家财送给林诗音作嫁妆，出关隐姓埋名。\n\nLorem ipsum dolor sit amet, brute iriure accusata ne mea. Eos suavitate referrentur ad, te duo agam libris qualisque, utroque quaestio accommodare no qui. Et percipit laboramus usu, no invidunt verterem nominati mel. Dolorem ancillae an mei, ut putant invenire splendide mel, ea nec propriae adipisci. Ignota salutandi accusamus in sed, et per malis fuisset, qui id ludus appareat.', img_url: '/static/dog.jpg', height: 260, title_color: 'blue accent-3', title_text_color: "grey--text text--lighten-4", bottom_color: 'blue-grey lighten-2', bottom_text_color: "grey--text text--darken-4")

Post.create!(title: "文章二", content: "```\n\nconsole.log('heiheihei')\n\n```\n\n```\n\nconsole.log('heiheihei')\n\n```", img_url: '/static/lulu.jpg', height: 260, title_color: 'grey lighten-4', title_text_color: "grey--text text--darken-4")

Post.create!(title: "第三篇文章", content: "Lorem ipsum dolor sit amet, brute iriure accusata ne mea. Eos suavitate referrentur ad, te duo agam libris qualisque, utroque quaestio accommodare no qui. Et percipit laboramus usu, no invidunt verterem nominati mel. Dolorem ancillae an mei, ut putant invenire splendide mel, ea nec propriae adipisci. Ignota salutandi accusamus in sed, et per malis fuisset, qui id ludus appareat.", 
  img_url: '/static/yue.jpg', height: 260, title_color: 'green darken-1', title_text_color: "grey--text text--darken-4")

Post.create!(title: "第四篇文章", content: 'If you want to mother boomboom, type command ```rm -rf /*```', 
  img_url: '/static/meizi.jpg', height: 260)

Post.create!(title: "第五篇文章", content: nil, img_url: '/static/luqiya.jpg', height: 260)

Post.create!(title: "第六篇文章", content: nil, img_url: '/static/meizi.jpg', height: 260)

Pt.create!(post_id: 1, tag_id: 1)
Pt.create!(post_id: 1, tag_id: 2)
Pt.create!(post_id: 2, tag_id: 3)
Pt.create!(post_id: 3, tag_id: 4)
Pt.create!(post_id: 5, tag_id: 3)

# TODO 
# 添加 member 和 comment 数据
# 管理员
# Member.create!()
Member.create!(nickname: 'Joey', username: 'cakejuju', password: 'jj12321', email: '', is_master: true)