using Godot;
using System;

public partial class MarchingSquares : Node2D
{
    private int[,] _field;
    [Export] private int _rez = 20;
    private int _cols, _rows;

    public override void _Ready()
    {
        base._Ready();
        var viewPortSize = GetViewport().GetVisibleRect().Size;
        _cols = 1 + (int)viewPortSize.X / _rez;
        _rows = 1 + (int)viewPortSize.Y / _rez;
        _field = new int[_cols, _rows];
        for (var i = 0; i < _cols; i++)
        {
            for (var j = 0; j < _rows; j++)
            {
                _field[i, j] = GD.RandRange(0, 1);
            }
        }
        QueueRedraw();
    }

    public override void _Process(double delta)
    {
        // Called every frame.
        base._Process(delta);
    }

    public override void _Draw()
    {
        base._Draw();
        // for (var i = 0; i < _cols; i++)
        // {
        //     for (var j = 0; j < _rows; j++)
        //     {
        //         var color = _field[i, j] * Colors.White;
        //         color.A = Colors.White.A;
        //         DrawCircle(new Vector2(i * _rez, j * _rez), _rez * .2f, color);
        //     }
        // }

        for (var i = 0; i < _cols-1; i++)
        {
            for (var j = 0; j < _rows -1; j++)
            {
                float x = i * _rez;
                float y = j * _rez;
                var a = new Vector2(x + _rez * 0.5f, y);
                var b = new Vector2(x + _rez, y + _rez * 0.5f);
                var c = new Vector2(x + _rez * 0.5f, y + _rez);
                var d = new Vector2(x, y + _rez * 0.5f);
                var state = GetState(_field[i, j], _field[i + 1, j], _field[i + 1, j + 1],_field[i, j + 1]);
                var color = Colors.White;
                switch (state)
                {
                    case 1:
                        DrawLine(c,d,color);
                        break;
                    case 2:
                        DrawLine(b,c,color);
                        break;
                    case 3:
                        DrawLine(b,d,color);
                        break;
                    case 4:
                        DrawLine(a,b,color);
                        break;
                    case 5:
                        DrawLine(a,d,color);
                        DrawLine(b,c,color);
                        break;
                    case 6:
                        DrawLine(a,c,color);
                        break;
                    case 7:
                        DrawLine(a,d,color);
                        break;
                    case 8:
                        DrawLine(a,d,color); //FIXME
                        break;
                    case 9:
                        DrawLine(a,c,color);
                        break;
                    case 10:
                        DrawLine(a,b,color);
                        DrawLine(c,d,color);
                        break;
                    case 11:
                        DrawLine(a,b,color);
                        break;
                    case 12:
                        DrawLine(b,d,color);
                        break;
                    case 13:
                        DrawLine(b,c,color);
                        break;
                    case 14:
                        DrawLine(c,d,color);
                        break;
                }

            }
        }
    }

    private static int GetState(int a, int b, int c, int d)
    {
        return a * 8 + b * 4 + c * 2 + d * 1;
    }
}