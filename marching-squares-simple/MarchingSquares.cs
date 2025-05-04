using Godot;
using System;

public partial class MarchingSquares : Node2D
{
    private float[][] _field;
    [Export] private int _rez = 10;
    private int _cols, _rows;

    public override void _Ready()
    {
        base._Ready();
        var viewPortSize = GetViewport().GetVisibleRect().Size;
        _cols = (int)viewPortSize.X / _rez;
        _rows = (int)viewPortSize.Y / _rez;
        
    }

    public override void _Process(double delta)
    {
        // Called every frame.
        base._Process(delta);
    }
    
    public override void _Draw()
    {
        base._Draw();
    }
}
