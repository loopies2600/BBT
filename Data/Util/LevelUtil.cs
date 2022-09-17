using Godot;
using System;
using System.Collections;
using System.Collections.Generic;

public class LevelUtil : Node
{
	public List<Vector2> floodFill(Vector2 startPos, UInt32 maxDistance, TileMap target, List<int> include)
	{
		Vector2[] dirs = {Vector2.Left, Vector2.Right, Vector2.Up, Vector2.Down};

		List<Vector2> possibleCells = new List<Vector2>();

		Stack<Vector2> stack = new Stack<Vector2>();
		stack.Push(startPos);

		while(stack.Count > 0)
		{
			Vector2 curTile = stack.Pop();

			if (possibleCells.Contains(curTile)) continue;

			Vector2 difference = ((curTile - startPos)) * new Vector2(16, 16);
			int distance = (int) difference.x + (int) difference.y;

			if (distance > maxDistance) continue;

			possibleCells.Add(curTile);

			foreach (Vector2 dir in dirs)
			{
				Vector2 coords = curTile + (dir * new Vector2(16, 16));

				if (!include.Contains(target.GetCellv(coords)))
				{
					continue;
				}

				if (possibleCells.Contains(coords))
				{
					continue;
				}

				stack.Push(coords);
			}
		}

		return possibleCells;
	}
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		List<Vector2> test = floodFill(new Vector2(0, 0), 2048, (TileMap) GetTree().Root.GetNode("Main/LevelLayout"), new List<int>(1) {-1});

		GD.Print(test);
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
