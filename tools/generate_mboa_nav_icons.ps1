Add-Type -AssemblyName System.Drawing

$drawingAssembly = [System.Drawing.Bitmap].Assembly.Location
Add-Type -ReferencedAssemblies $drawingAssembly -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

public static class MboaNavIconGenerator
{
    private static GraphicsPath RoundedRectangle(RectangleF bounds, float radius)
    {
        var path = new GraphicsPath();
        float diameter = radius * 2;
        path.AddArc(bounds.X, bounds.Y, diameter, diameter, 180, 90);
        path.AddArc(bounds.Right - diameter, bounds.Y, diameter, diameter, 270, 90);
        path.AddArc(bounds.Right - diameter, bounds.Bottom - diameter, diameter, diameter, 0, 90);
        path.AddArc(bounds.X, bounds.Bottom - diameter, diameter, diameter, 90, 90);
        path.CloseFigure();
        return path;
    }

    private static void DrawRoad(Graphics graphics, Color color, float width, params PointF[] points)
    {
        using (var pen = new Pen(color, width))
        {
            pen.StartCap = LineCap.Round;
            pen.EndCap = LineCap.Round;
            pen.LineJoin = LineJoin.Round;
            graphics.DrawLines(pen, points);
        }
    }

    private static void DrawPin(Graphics graphics, float x, float y, float radius, Color color)
    {
        using (var pin = new SolidBrush(color))
        using (var center = new SolidBrush(Color.White))
        {
            graphics.FillPolygon(pin, new[]
            {
                new PointF(x - radius * 0.82f, y + radius * 0.15f),
                new PointF(x + radius * 0.82f, y + radius * 0.15f),
                new PointF(x, y + radius * 1.55f)
            });
            graphics.FillEllipse(pin, x - radius, y - radius, radius * 2, radius * 2);
            graphics.FillEllipse(center, x - radius * 0.42f, y - radius * 0.42f, radius * 0.84f, radius * 0.84f);
        }
    }

    public static Bitmap Render(int size)
    {
        var bitmap = new Bitmap(size, size, PixelFormat.Format32bppArgb);
        using (var graphics = Graphics.FromImage(bitmap))
        using (var background = new SolidBrush(Color.FromArgb(11, 93, 59)))
        using (var phone = new SolidBrush(Color.FromArgb(23, 49, 41)))
        using (var phoneEdge = new Pen(Color.FromArgb(106, 163, 147), 8))
        using (var screenBrush = new SolidBrush(Color.FromArgb(247, 245, 237)))
        using (var mapBrush = new SolidBrush(Color.FromArgb(220, 227, 224)))
        using (var road = new Pen(Color.White, 15))
        using (var sideRoad = new Pen(Color.FromArgb(185, 197, 192), 9))
        using (var mainRoad = new Pen(Color.FromArgb(213, 166, 45), 17))
        using (var route = new Pen(Color.FromArgb(25, 144, 166), 16))
        using (var notch = new SolidBrush(Color.FromArgb(12, 31, 30)))
        {
            graphics.SmoothingMode = SmoothingMode.AntiAlias;
            graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
            graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;
            graphics.Clear(Color.FromArgb(11, 93, 59));
            graphics.ScaleTransform(size / 512f, size / 512f);
            graphics.FillRectangle(background, 0, 0, 512, 512);

            using (var body = RoundedRectangle(new RectangleF(74, 20, 364, 472), 58))
            {
                graphics.FillPath(phone, body);
                graphics.DrawPath(phoneEdge, body);
            }

            using (var screen = RoundedRectangle(new RectangleF(102, 64, 308, 390), 14))
            {
                graphics.FillPath(screenBrush, screen);
            }

            using (var speaker = RoundedRectangle(new RectangleF(218, 36, 76, 12), 6))
            {
                graphics.FillPath(notch, speaker);
            }

            GraphicsState state = graphics.Save();
            graphics.SetClip(new RectangleF(102, 64, 308, 390));
            graphics.FillRectangle(mapBrush, 102, 64, 308, 390);

            road.StartCap = LineCap.Round;
            road.EndCap = LineCap.Round;
            road.LineJoin = LineJoin.Round;
            sideRoad.StartCap = LineCap.Round;
            sideRoad.EndCap = LineCap.Round;
            sideRoad.LineJoin = LineJoin.Round;
            mainRoad.StartCap = LineCap.Round;
            mainRoad.EndCap = LineCap.Round;
            mainRoad.LineJoin = LineJoin.Round;
            route.StartCap = LineCap.Round;
            route.EndCap = LineCap.Round;
            route.LineJoin = LineJoin.Round;

            graphics.DrawLines(road, new[] { new PointF(92, 132), new PointF(220, 222), new PointF(428, 222) });
            graphics.DrawLines(road, new[] { new PointF(82, 304), new PointF(180, 232), new PointF(264, 142), new PointF(420, 142) });
            graphics.DrawLines(road, new[] { new PointF(116, 464), new PointF(230, 340), new PointF(420, 340) });
            graphics.DrawLines(sideRoad, new[] { new PointF(150, 56), new PointF(150, 466) });
            graphics.DrawLines(sideRoad, new[] { new PointF(380, 56), new PointF(380, 466) });
            graphics.DrawLine(mainRoad, 320, 62, 320, 456);
            graphics.DrawLine(mainRoad, 102, 324, 410, 324);
            DrawRoad(graphics, Color.FromArgb(25, 144, 166), 17,
                new PointF(176, 380), new PointF(230, 330), new PointF(230, 274),
                new PointF(285, 274), new PointF(302, 250));
            DrawPin(graphics, 176, 366, 23, Color.FromArgb(25, 144, 166));
            DrawPin(graphics, 302, 178, 39, Color.FromArgb(199, 72, 62));
            graphics.Restore(state);
        }
        return bitmap;
    }

    public static void SavePng(string path, int size)
    {
        using (var bitmap = Render(size))
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            bitmap.Save(path, ImageFormat.Png);
        }
    }

    public static void SaveIco(string path, int size)
    {
        using (var bitmap = Render(size))
        using (var image = new MemoryStream())
        {
            bitmap.Save(image, ImageFormat.Png);
            byte[] png = image.ToArray();
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            using (var file = new FileStream(path, FileMode.Create, FileAccess.Write))
            using (var writer = new BinaryWriter(file))
            {
                writer.Write((ushort)0);
                writer.Write((ushort)1);
                writer.Write((ushort)1);
                writer.Write((byte)0);
                writer.Write((byte)0);
                writer.Write((byte)0);
                writer.Write((byte)0);
                writer.Write((ushort)1);
                writer.Write((ushort)32);
                writer.Write(png.Length);
                writer.Write(22);
                writer.Write(png);
            }
        }
    }
}
'@

$root = Split-Path $PSScriptRoot -Parent
$pngs = [ordered]@{
    'images/mboa_nav_logo.png' = 512
    'web/favicon.png' = 48
    'web/icons/Icon-192.png' = 192
    'web/icons/Icon-512.png' = 512
    'web/icons/Icon-maskable-192.png' = 192
    'web/icons/Icon-maskable-512.png' = 512
    'android/app/src/main/res/mipmap-mdpi/ic_launcher.png' = 48
    'android/app/src/main/res/mipmap-hdpi/ic_launcher.png' = 72
    'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png' = 96
    'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png' = 144
    'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png' = 192
}

$iosIcons = @{
    'Icon-App-20x20@1x.png' = 20; 'Icon-App-20x20@2x.png' = 40; 'Icon-App-20x20@3x.png' = 60
    'Icon-App-29x29@1x.png' = 29; 'Icon-App-29x29@2x.png' = 58; 'Icon-App-29x29@3x.png' = 87
    'Icon-App-40x40@1x.png' = 40; 'Icon-App-40x40@2x.png' = 80; 'Icon-App-40x40@3x.png' = 120
    'Icon-App-60x60@2x.png' = 120; 'Icon-App-60x60@3x.png' = 180
    'Icon-App-76x76@1x.png' = 76; 'Icon-App-76x76@2x.png' = 152
    'Icon-App-83.5x83.5@2x.png' = 167; 'Icon-App-1024x1024@1x.png' = 1024
}
foreach ($entry in $iosIcons.GetEnumerator()) {
    $pngs["ios/Runner/Assets.xcassets/AppIcon.appiconset/$($entry.Key)"] = $entry.Value
}

$macIcons = @{
    'app_icon_16.png' = 16; 'app_icon_32.png' = 32; 'app_icon_64.png' = 64
    'app_icon_128.png' = 128; 'app_icon_256.png' = 256; 'app_icon_512.png' = 512
    'app_icon_1024.png' = 1024
}
foreach ($entry in $macIcons.GetEnumerator()) {
    $pngs["macos/Runner/Assets.xcassets/AppIcon.appiconset/$($entry.Key)"] = $entry.Value
}

foreach ($entry in $pngs.GetEnumerator()) {
    [MboaNavIconGenerator]::SavePng((Join-Path $root $entry.Key), $entry.Value)
}
[MboaNavIconGenerator]::SaveIco((Join-Path $root 'windows/runner/resources/app_icon.ico'), 256)
Write-Output "Generated $($pngs.Count + 1) Mboa Nav launcher icons."