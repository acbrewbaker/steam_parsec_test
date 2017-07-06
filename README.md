# Performance Testing Parsec Versus Steam-In-Home-Streaming + VPN Over The WAN

I created this repo to give you insight into the functions and data used to generate the graphs we used in our blog post describing the performance of [Parsec](https://parsec.tv/) versus Steam-in-home-streaming + Hamachi while connecting to a cloud server hosted on AWS. The AWS server was running Windows Server 2016. We used a g2.2xlarge. At Parsec, we really admire this Steam-in-home-streaming + VPN set up. It's what inspired us to build our software. A lot of credit belongs to Larry Gadea who wrote the [original post](https://lg.io/2015/07/05/revised-and-much-faster-run-your-own-highend-cloud-gaming-service-on-ec2.html) inspiring [our technology](https://blog.parsec.tv/description-of-parsec-technology-b2738dcc3842).

The [g2.2xlarge](https://aws.amazon.com/ec2/instance-types/) features:
* High Frequency Intel Xeon E5-2670 (Sandy Bridge) Processors
* High-performance NVIDIA GPUs, each with 1,536 CUDA cores and 4GB of video memory. They use the K520 GRID cards based on the [Kepler Architecture](https://en.wikipedia.org/wiki/Kepler_(microarchitecture)). They are old, blame Amazon.

The data was produced using [FRAPS](http://www.fraps.com/) connecting to the AWS instance with a Windows 10 client with a GTX 1070 and Intel 6700k. This machine definitely wouldn't need to use a cloud server to play games ;). The client has a 1Gbps fiber internet connection and is connected via an ethernet cable. 

The tests were done playing GRID, Just Cause 3, and Tomb Raider 2013. The AWS K520 card really had a hard time keeping up with Just Cause 3, but the data is included. There are some graphs with the data excluded too.

A note about the code:
* I'm an R novice. Please forgive me if the code is not well structured or uses unnecessary steps or just isn't good. I tried my best.
  * That being said, since I am an R novice, please let me know if there are logical errors in this code. I'm aiming to be transparent with my methodology and the data we used to generate a comparison with Steam-in-home-streaming + Hamachi versus Parsec.


It has been our goal to lower latency as much as possible without sacraficing frame rates. At times, this causes us to lower video quality based on network capacity, but we always aim to maintain 60 FPS no matter what the networking conditions. We even built our own [networking protocol](https://blog.parsec.tv/a-primer-on-building-udp-networking-protocols-how-we-deliver-low-latency-cloud-gaming-1987806feb62) to make this possible.

The results demonstrate that under adverse conditions and normal networking conditions, Parsec is much more likely to maintain 60 FPS than the Steam + VPN solution. Using a tool called [Clumsy](https://jagt.github.io/clumsy/), we simulated networking conditions where there was 3% loss and then another scenario with 50% out of order packets. 

[Normal Internet, Parsec vs. Steam + VPN]: https://github.com/parsec-cloud/steam_parsec_test/blob/master/graphs/No%20Change%20To%20Internetplatform_density.jpg "Normal Internet"

[3% Loss, Parsec vs. Steam + VPN]: https://github.com/parsec-cloud/steam_parsec_test/blob/master/graphs/Three%20Percent%20Lossplatform_density.jpg "3% Packet Loss"

[50% Out Of Order Packets, Parsec vs. Steam + VPN]: https://github.com/parsec-cloud/steam_parsec_test/blob/master/graphs/Fifty%20Percent%20Out%20Of%20Order%20Packetsplatform_density.jpg "50% Out Of Order Packets"

We did similar tests on Parsec (our networking versus TCP). Those results are demonstrated in [this video](https://vimeo.com/211552100). Our proprietary networking definitely outperforms the TCP version of our application.
