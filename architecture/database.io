// Media will be stored in S3 database (posts_media folder)

Table follows {
  following_user_id string [not null]
  followed_user_id string [not null]
  created_at timestamp [not null, default: `now()`]
}

Table users {
  id string [primary key]
  email string [unique, not null]
  password string [not null]
  firstname string [not null]
  lastname string [not null]
  created_at timestamp [not null, default: `now()`]
}

Table posts {
  id string [primary key]
  text string [not null]
  author_id string [not null]
  geo string [not null]
  img string[]
  created_at timestamp [not null, default: `now()`]
}

Table comments {
  id string [primary key]
  author_id string [not null]
  text string [not null]
  post_id string [not null]
  reply_comment_id string [not null]
  created_at timestamp [not null, default: `now()`]
}

Table rating {
  user_id string [not null]
  post_id string [not null]
  created_at timestamp [not null, default: `now()`]
}

Ref: posts.author_id > users.id

Ref: users.id < follows.following_user_id

Ref: users.id < follows.followed_user_id

Ref: comments.author_id > users.id

Ref: comments.post_id > posts.id

Ref: comments.reply_comment_id > comments.id

Ref: users.id < rating.user_id

Ref: users.id < rating.post_id
