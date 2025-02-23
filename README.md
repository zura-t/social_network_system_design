# System Design of social network for course by System Design

### Functional requirements

- publish posts about travelling with photos, some description, and info about geo location.
- rate, and comment other travellers posts
- follow other people, and view their activity
- find popular places to go, and view related posts
- view other travellers and your personal feed, based on following pages in desc order.

### Non-functional requirements

- DAU 10 000 000
- Audience CIS countries
- Always store data
- availability 99,95%
- Usage spikes expected during peak travel/holiday seasons (e.g., summer vacations, winter holidays)
- app should work on different devices
- Limits
  - max number of followings 10000
  - max number of followers per user 1 000 000
  - max number of posts per day 1000
  - max number of photos in one post 5
  - max size of image 1,5MB
- Activity
  - Posts
    - publish one post per week
    - view feeds 3 times per day
  - Comments
    - write 3 comments per week
    - read 10 comments daily
  - Ratings
    - create 5 ratings per day
    - view 5 ratings per day
  - Discovery
    find popular places 3 times per week
- Timings
  - create post 2 seconds
  - rate, create comment, follow someone 1 second
  - find places 2 seconds
  - view feed 2 seconds

## Basic calculations

### Posts

RPS(write) = 10kk * 1 post per week / 7 / 86400 ~= 17
RPS(read) = 10kk * 3 time per day / 86400 ~= 350

### Comments

RPS(write) = 10kk * 3 comments per week / 7 / 86400 ~= 50
RPS(read) = 10kk * read 10 comments per day / 86400 ~= 1200

### Ratings

RPS(write) = 10kk * 5 ratings per day / 86400 ~= 600
RPS(read) = 10kk * 5 ratings per day / 86400 ~= 600


### Places

RPS(read) = 10kk * 3 time per week view popular places / 7 / 86400 ~= 60


## AVG size of data
#### Post:
- id (8 bytes)
- author_id (8 bytes)
- text (up to 500 bytes)
- []img (up to 500 bytes) // links to images
- geo (up to 100 bytes)
- created_at (8 bytes)

**Total**: 8B + 8B + 500B + 500B + 100B + 8B = 2KB

---
#### Comment:
- id (8 bytes)
- post_id (8 bytes)
- author_id (8 bytes)
- text (up to 250 bytes)
- created_at (8 bytes)

**Total**: 8B + 8B + 8B + 250B + 8B = 300B

---

#### Rating:
- id (8 bytes)
- post_id (8 bytes)
- author_id (8 bytes)
- value INT8 (1 byte)
- created_at (8 bytes)

**Total** 8B + 8B + 8B + 1B + 8B = 33B

--- 

## Traffic

### Posts

Metainformation = id + author_id + text + geo + created_at = 8 + 8 + 500 + 100 + 8 = 624B ~= 0.6KB

- Traffic (write, meta) = 17 * 0.6KB ~= 10KB/s
- Traffic (write, media) = 17 * 3MB ~= 51MB/s
- Traffic (read, meta) = 350 * 15 * 0.6Kb ~= 3.1MB/s
- Traffic (read, media) = 350 * 15 * 3MB ~= 15.75GB/s

### Comments

- Traffic (write) = 50 * 300B = 15KB/s
- Traffic (read) = 1200 * 300B = 400KB/s

### Ratings

- Traffic (write) = 600 * 33B = 20KB/s
- Traffic (read) = 600 * 33B = 20KB/s