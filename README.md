# Performance Testing Parsec Versus Steam-In-Home-Streaming + VPN Over The WAN

I created this repo to give you insight into the functions and data used to generate the graphs we used in our blog post describing the performance of [Parsec](https://parsec.tv/) versus Steam-in-home-streaming + Hamachi while connecting to a cloud server hosted on AWS. The AWS server was running Windows Server 2016. We used a g2.2xlarge. At Parsec, we really admire this Steam-in-home-streaming + VPN set up. It's what inspired us to build our software. A lot of credit belongs to Larry Gadea who wrote the [original post](https://lg.io/2015/07/05/revised-and-much-faster-run-your-own-highend-cloud-gaming-service-on-ec2.html) inspiring [our technology](https://blog.parsec.tv/description-of-parsec-technology-b2738dcc3842).

The [g2.2xlarge](https://aws.amazon.com/ec2/instance-types/) features:
* High Frequency Intel Xeon E5-2670 (Sandy Bridge) Processors
* High-performance NVIDIA GPUs, each with 1,536 CUDA cores and 4GB of video memory. They use the K520 GRID cards based on the [Kepler Architecture](https://en.wikipedia.org/wiki/Kepler_(microarchitecture)). They are old, blame Amazon.

A note about the code:
* I'm an R novice. Please forgive me if the code is not well structured or uses unnecessary steps or just isn't good. I tried my best :).
  * That being said, since I am an R novice, please let me know if there are logical errors in this code. I'm aiming to be transparent with my methodology and the data we used to generate a comparison with Steam-in-home-streaming + Hamachi versus Parsec.
