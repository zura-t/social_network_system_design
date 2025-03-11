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
- Usage spikes expected during summer vacations (increases 1,5 times), and winter holidays (increases 5 times)
- app should work on different devices
- Limits
  - max number of followings 10000
  - max number of followers per user 1 000 000
  - max number of posts per day 1000
  - max number of photos in one post 3
  - max size of image 1MB
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
    - find popular places 3 times per week
  - Followings
    - follow 2 new users per day
- Timings
  - create post 2 seconds
  - rate a post 1 second
  - create comment 1 second
  - find places 2 seconds
  - view feed 2 seconds
  - follow user 1 second

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

### Followings

RPS(write) = 10kk * 2 users per day / 86400 ~= 231


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
- created_at (8 bytes)

**Total** 8B + 8B + 8B + 8B = 32B

---

#### Following
- id (8 bytes)
- following_id (8 bytes)
- follower_id (8 bytes)
- created_at (8 bytes)

**Total** 8B + 8B + 8B + 8B = 32B

--- 

## Traffic

### Posts

Metainformation = id + author_id + text + geo + created_at = 8 + 8 + 500 + 100 + 8 = 624B ~= 0.6KB

- Traffic (write, meta) = 17 * 0,6KB ~= 10KB/s
- Traffic (write, media) = 17 * 3MB ~= 51MB/s
- Traffic (read, meta) = 350 * 0,6Kb ~= 3,2MB/s
- Traffic (read, media) = 350 * 3MB ~= 1,1GB/s

### Comments

- Traffic (write) = 50 * 300B = 15KB/s
- Traffic (read) = 1200 * 300B = 400KB/s

### Ratings

- Traffic (write) = 600 * 32B = 20KB/s
- Traffic (read) = 600 * 32B = 20KB/s

### Followings

- Traffic (write) = 231 * 32 bytes = 8KB/s

---

## Capacity

Service operation time = 1 year

### Posts

Capacity = 10kB/s * 86400 * 365 = 315,5Gb

RPS = 367

HDD
iops = 367 / 100 iops ~= 4 disks
throughput = 10KB/s / 100mb/s ~= 1 disk
capacity = 315,5GB / 1TB ~= 1 disk
Total disks = 4 disks

SSD(SATA)
iops = 367 / 1000 iops ~= 1 disk
throughput = 10KB/s / 500mb/s ~= 1 disk
capacity = 315,5GB / 1TB ~= 1 disk
Total disks = 1 disk


#### Media

We'll store media in S3
capacity = 51MB/s * 86400 * 365 ~= 1,8PB
total rps = 17 + 350 = 367

HDD
iops = 367 / 100 iops ~= 4 disks
throughput = 51MB/s / 100MB/s ~= 1 disk
discs for capacity = 1,8PB / 32TB ~= 57 disks
Total disks = 57 disks

SSD(SATA)
iops = 367 / 1000 iops ~= 1 disk
throughput = 51MB/s / 500MB/s ~= 1 disk
capacity = 1,8PB / 100TB = 18 disks
Total disks = 18 disks

### Comments

total rps = 50 + 1200 = 1250
capacity = 15KB/s * 86400 * 1250 ~= 1,62TB

HDD
iops = 1250 / 100 iops ~= 13 disks
throughput = 15KB/s / 100mb/s ~= 1 disk
capacity = 1,62TB / 1TB ~= 2 disks
Total disks = 13 disks

SSD(SATA)
iops = 1250 / 1000 iops ~= 2 disks
throughput = 15KB/s / 500mb/s ~= 1 disk
capacity = 1,62TB / 1TB ~= 2 disks
Total disks = 2 disks

### Rating

total rps = 600 + 600 = 1200
capacity = 20Kb/s * 86400 * 1200 ~= 2Tb

HDD
iops = 1200 / 100 iops = 12 disks
throughput = 20kb/s / 100mb/s ~= 1 disk
capacity = 2Tb / 1tb = 2 disk
Total disks = 12 disks

SSD(SATA)
iops = 1200/ 1000 iops ~= 2 disks
throughput = 20Kb/s / 500mb/s ~= 1 disk
capacity = 2tb / 1tb = 2 disks
Total disks = 2 disks

### Followings

total rps = 231
capacity = 8kb/s * 86400 * 231 = 160gb

HDD
iops = 231 / 100 iops ~= 3 disks
throughput = 8KB/s / 100mb/s ~= 1 disk
capacity = 160 GB / 1tb ~= 1disk
Total disks = 3 disks

SSD(SATA)
iops = 231 / 1000 iops ~= 1 disk
throughput = 8kb/s / 500mb/s ~= 1 disk
capacity = 160GB / 1tb ~= 1 disk
Total disks = 1 disk
