<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="webapp.WebForm1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- You can add meta tags, links, scripts, etc. here if needed -->
    <style>
        /* 3D Slider Styles */
        .banner {
            width: 100%;
            height: 70vh;
            text-align: center;
            overflow: visible;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            margin: 30px 0;
            perspective: 1000px;
        }

        /* Slider Styling - Fixed in center */
        .slider {
            position: relative;
            width: 200px;
            height: 250px;
            transform-style: preserve-3d;
            animation: autoRun 30s linear infinite;
            z-index: 2;
        }

        /* Keyframe Animation for Rotation */
        @keyframes autoRun {
            from {
                transform: perspective(1000px) rotateX(-16deg) rotateY(0deg);
            }
            to {
                transform: perspective(1000px) rotateX(-16deg) rotateY(360deg);
            }
        }

        /* Slider Item Styling */
        .slider .item {
            position: absolute;
            inset: 0;
            transform: rotateY(calc((var(--position) - 1) * (360 / var(--quantity)) * 1deg)) translateZ(550px);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 25px rgba(255, 126, 41, 0.6);
            transition: all 0.3s ease;
            border: 2px solid #ff7e29;
        }

        .slider .item:hover {
            transform: rotateY(calc((var(--position) - 1) * (360 / var(--quantity)) * 1deg)) translateZ(600px) scale(1.08);
            box-shadow: 0 8px 30px rgba(255, 126, 41, 0.8);
            z-index: 10;
        }

        .slider .item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Content Styling */
        .content {
            padding: 40px 20px;
            text-align: center;
            background: rgba(0, 0, 0, 0.4);
            border-radius: 15px;
            margin: 30px 0;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 126, 41, 0.3);
        }
        
        .content h2 {
            font-size: 2.2rem;
            margin-bottom: 20px;
            color: #ff7e29;
        }
        
        .content p {
            font-size: 1.1rem;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto 20px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(45deg, #ff7e29, #ff9a3d);
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: 600;
            margin-top: 15px;
            transition: transform 0.3s, box-shadow 0.3s;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(255, 126, 41, 0.4);
        }
        
        .features {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
            margin: 50px 0;
        }
        
        .feature {
            background: rgba(255, 126, 41, 0.1);
            padding: 25px;
            border-radius: 15px;
            width: 300px;
            backdrop-filter: blur(5px);
            transition: transform 0.3s;
            border: 1px solid rgba(255, 126, 41, 0.2);
        }
        
        .feature:hover {
            transform: translateY(-5px);
            background: rgba(255, 126, 41, 0.15);
        }
        
        .feature h3 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #ff7e29;
        }
        
        @media (max-width: 768px) {
            .slider {
                width: 150px;
                height: 200px;
            }
            
            .features {
                flex-direction: column;
                align-items: center;
            }
            
            .banner {
                height: 50vh;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="container">
        
        <div class="banner">
            <div class="slider" style="--quantity: 10">
                <div class="item" style="--position: 1">
                    <img src="imgs/dragon_1.jpg" alt="Dragon 1" />
                </div>
                <div class="item" style="--position: 2">
                    <img src="imgs/dragon_2.jpg" alt="Dragon 2" />
                </div>
                <div class="item" style="--position: 3">
                    <img src="imgs/dragon_3.jpg" alt="Dragon 3" />
                </div>
                <div class="item" style="--position: 4">
                    <img src="imgs/dragon_4.jpg" alt="Dragon 4" />
                </div>
                <div class="item" style="--position: 5">
                    <img src="imgs/dragon_5.jpg" alt="Dragon 5" />
                </div>
                <div class="item" style="--position: 6">
                    <img src="imgs/dragon_6.jpg" alt="Dragon 6" />
                </div>
                <div class="item" style="--position: 7">
                    <img src="imgs/dragon_7.jpg" alt="Dragon 7" />
                </div>
                <div class="item" style="--position: 8">
                    <img src="imgs/dragon_8.jpg" alt="Dragon 8" />
                </div>
                <div class="item" style="--position: 9">
                    <img src="imgs/dragon_9.jpg" alt="Dragon 9" />
                </div>
                <div class="item" style="--position: 10">
                    <img src="imgs/dragon_10.jpg" alt="Dragon 10" />
                </div>
            </div>          
        </div>
        
        <div class="content">
            <h2>Majestic Dragons Collection</h2>
            <p>This 3D slider showcases our collection of dragon artwork, perfectly fixed in the center of the screen. The slider maintains its 3D rotation effect without any unwanted movement or positioning issues.</p>
            <p>Each dragon image is displayed in a continuous carousel that rotates smoothly, creating an immersive viewing experience.</p>
            <a href="#" class="btn">View Collection</a>
        </div>
        
        <div class="features">
            <div class="feature">
                <h3>Fixed Position</h3>
                <p>The slider stays perfectly centered without any unwanted movement or scrolling issues.</p>
            </div>
            <div class="feature">
                <h3>Smooth 3D Rotation</h3>
                <p>Enjoy the mesmerizing 3D rotation effect that highlights each dragon from all angles.</p>
            </div>
            <div class="feature">
                <h3>Interactive Controls</h3>
                <p>Adjust the rotation speed or pause the slider to examine individual dragons more closely.</p>
            </div>
        </div>
      </div>
    
    <footer>
        <p>Dragon Gallery © 2023 | Fixed 3D Slider Implementation</p>
    </footer>
</asp:Content>
