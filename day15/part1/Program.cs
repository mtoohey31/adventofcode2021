class Node
{
    public int risk;
    public int dist = int.MaxValue;
    public HashSet<Node> neighbours = new HashSet<Node>();

    public Node(int risk)
    {
        this.risk = risk;
    }

    static public void Main(String[] args)
    {
        string[] inputLines = System.IO.File.ReadAllLines("../input");

        int size = inputLines.Length;

        Node[,] nodes = new Node[size, size];

        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                nodes[x, y] = new Node(inputLines[y][x] - 48);
            }
        }

        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                nodes[x, y].SetNeighbours(nodes, x, y);
            }
        }

        Node start = nodes[0, 0];
        start.dist = 0;
        Node dest = nodes[nodes.GetUpperBound(0), nodes.GetUpperBound(1)];

        HashSet<Node> unvisited = new HashSet<Node>();

        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                unvisited.Add(nodes[x, y]);
            }
        }

        Node curr = start;
        while (unvisited.Contains(dest))
        {
            foreach (Node neighbour in curr.neighbours)
            {
                if (unvisited.Contains(neighbour))
                {
                    int distFromCurr = curr.dist + neighbour.risk;
                    if (neighbour.dist > distFromCurr)
                    {
                        neighbour.dist = distFromCurr;
                    }
                }
            }
            unvisited.Remove(curr);
            curr = unvisited.MinBy((n) => n.dist);
        }

        Console.WriteLine(dest.dist);
    }

    public void SetNeighbours(Node[,] nodes, int x, int y)
    {
        if (x > 0)
        {
            neighbours.Add(nodes[x - 1, y]);
        }
        if (y > 0)
        {
            neighbours.Add(nodes[x, y - 1]);
        }
        if (x < nodes.GetUpperBound(0))
        {
            neighbours.Add(nodes[x + 1, y]);
        }
        if (y < nodes.GetUpperBound(1))
        {
            neighbours.Add(nodes[x, y + 1]);
        }
    }
}
