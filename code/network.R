# Visualizing networks

# Load packages ----
library(igraph)
library(ggraph)
library(dplyr)

# Basic node-link diagrams ----
# Lots of functions in igraph to generate random graphs
g <- sample_gnm(15, 30)

# Base R plot method
par(mar = rep(0, 4))
plot(g)

# Create a directed one
g <- sample_gnm(24, 36, directed = TRUE)
plot(g)

# Create one with loops
g <- sample_gnm(15, 45, directed = TRUE, loops = TRUE)
plot(g)

# Convert the graph to a matrix
g %>% 
  as.matrix() %>% 
  as.matrix() 

# Plot with ggplot2 using ggraph
ggraph(graph = g, layout = "auto") +
  # Simplest choice for edges is "link"
  geom_edge_link(arrow = arrow(angle = 45, 
                               length = unit(0.1, "inches"), 
                               type = "closed"),
                 end_cap = circle(0.1, "inches")) +
  # Draw the loops separately
  geom_edge_loop() +
  # Simples choice for nodes is "point"
  geom_node_point(size = 5, color = "purple") +
  # You can change the coordinates if you want some more
  # margin around the network.
  coord_cartesian(ylim = c(-2, 2)) +
  # Theme from ggraph is very plain
  # Could still use any ggplot2 theme, especially if you
  # want to see the values on the x/y axes.
  theme_graph()

# Add some attributes ----
# Try to make a graph of the grizzly life-cycle diagram from the
# lecture slides.
g <- make_graph(c(1, 2, 
                  2, 3, 
                  3, 4,
                  4, 5,
                  4, 1,
                  5, 1, 
                  5, 5),
                directed = TRUE) %>% 
  set_vertex_attr("names", value = c("0", "1", "2", "3", "4+")) %>% 
  set_edge_attr("vitalrates", 
                value = c("S0", "S1", "S2", "S3", "F3", "F4", "S4"))
# If you are adding attributes to the nodes, 
# print out the nodes (in order):
vertex(g)
# Similarly, for the edges:
edge(g)

# Base plot
plot(g) # no change

# Customize with ggraph
ggraph(g, layout = "linear") +
  geom_edge_arc(aes(circular = !((1:7) %in% (5:6)),
                    # Put the attribute name in the aesthetics
                    label = vitalrates),
                # Flip the arcs with argument strength; negative values flip
                strength = -0.75,
                # To move the labels vertically, specify BOTH 
                # label_dodge and angle_calc
                label_dodge = unit(0.2, "inches"),
                angle_calc = "along",
                # To move the labels horizontally, specify both
                # label_push and angle_calc
                label_push = unit(0.1, "inches"),
                arrow = arrow(angle = 15, 
                              length = unit(0.1, "inches"), 
                              type = "closed"),
                end_cap = circle(0.1, "inches")) +
  geom_edge_loop(aes(label = vitalrates),
                 label_dodge = unit(0.1, "inches"),
                 angle_calc = "along",
                 label_push = unit(0.1, "inches"),
                 arrow = arrow(angle = 15, 
                               length = unit(0.1, "inches"), 
                               type = "closed"),
                 end_cap = circle(0.1, "inches")) +
  # Put the attribute name in the aesthetics
  geom_node_label(aes(label = names)) +
  # Control the plot limits if you want more margin
  coord_cartesian(xlim = c(-1, 6),
                  ylim = c(-0.1, 1.5)) +
  theme_graph()

